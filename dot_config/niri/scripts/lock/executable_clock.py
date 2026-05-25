#!/usr/bin/env python3
"""
Baroque Analog Clock Generator for Hyprlock.
Generates a highly detailed, classical clock image using current system time.
Supports custom configurations, robust font discovery, and crisp supersampling.
"""

import argparse
import datetime
import math
import os
import re
import shutil
import subprocess
import sys

import numpy as np
from PIL import Image, ImageDraw, ImageFont


def parse_config(file_path: str) -> dict[str, str | tuple[int, int, int, int]]:
    """
    Parses colors and font from a config file using the format:
    $variable = value
    """
    config = {
        "font": "serif",
        "background_color": (42, 47, 36, 255),  # Default: 2a2f24FF
        "foreground_color": (241, 234, 220, 255),  # Default: f1eadcFF
        "main_color": (166, 132, 141, 255),  # Default: a6848dFF
    }

    if not file_path or not os.path.exists(file_path):
        return config

    try:
        with open(file_path, "r", encoding="utf-8") as f:
            for line in f:
                # Strip comments and white spaces
                line = line.split("#", 1)[0].strip()
                if not line:
                    continue

                match = re.match(r"^\$(\w+)\s*=\s*(.+)$", line)
                if match:
                    key = match.group(1).strip()
                    val = match.group(2).strip()

                    # Strip wrapping quotes if present
                    if (val.startswith('"') and val.endswith('"')) or (
                        val.startswith("'") and val.endswith("'")
                    ):
                        val = val[1:-1].strip()

                    if key == "font":
                        config["font"] = val
                    elif key in ["background_color", "foreground_color", "main_color"]:
                        color_val = val.lstrip("#").lstrip("0x")
                        if len(color_val) == 6:
                            color_val += "FF"
                        if len(color_val) == 8:
                            try:
                                r = int(color_val[0:2], 16)
                                g = int(color_val[2:4], 16)
                                b = int(color_val[4:6], 16)
                                a = int(color_val[6:8], 16)
                                config[key] = (r, g, b, a)
                            except ValueError:
                                pass
    except Exception as e:
        print(f"Warning: Failed to parse config file: {e}", file=sys.stderr)

    return config


def find_font_path(font_name: str):
    """
    Locates the font file on Linux using fc-match, falling back to standard serif paths.
    """
    if shutil.which("fc-match"):
        try:
            result = subprocess.run(
                ["fc-match", "-f", "%{file}", font_name],
                capture_output=True,
                text=True,
                check=True,
            )
            path = result.stdout.strip()
            if (
                path
                and os.path.exists(path)
                and path.lower().endswith((".ttf", ".otf", ".ttc"))
            ):
                return path
        except Exception:
            pass

    # Standard fallbacks if fc-match fails or isn't present
    fallbacks = [
        "/usr/share/fonts/TTF/DejaVuSerif.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSerif.ttf",
        "/usr/share/fonts/liberation/LiberationSerif-Regular.ttf",
        "/usr/share/fonts/truetype/liberation/LiberationSerif-Regular.ttf",
        "/usr/share/fonts/gsfonts/URWBook-Roman.otf",
    ]
    for path in fallbacks:
        if os.path.exists(path):
            return path

    # Shallow scan for any serif font in standard directories
    try:
        for root, _, files in os.walk("/usr/share/fonts"):
            for file in files:
                if file.lower().endswith((".ttf", ".otf")) and "serif" in file.lower():
                    return os.path.join(root, file)
    except Exception:
        pass

    return None


def transform_points_np(points, angle, cx, cy):
    """
    Rotates a list of (u, v) coordinates by `angle` (radians) and translates them to (cx, cy).
    u-axis maps pointing up, v-axis maps pointing right.
    """
    pts = np.array(points, dtype=np.float32)
    cos_a = np.cos(angle)
    sin_a = np.sin(angle)

    # Clockwise rotation and mapping matrix
    transform_matrix = np.array([[sin_a, cos_a], [-cos_a, sin_a]], dtype=np.float32)

    rotated = pts @ transform_matrix.T
    rotated[:, 0] += cx
    rotated[:, 1] += cy
    return [tuple(p) for p in rotated]


def get_rose_points_np(cx, cy, r_base, frequency, steps=1000):
    """
    Generates coordinates for a mathematical Rose Curve (guilloché-like filigree).
    """
    theta = np.linspace(0, 2 * np.pi, steps)
    r = r_base * (0.45 + 0.55 * np.abs(np.cos(frequency * theta)))
    x = cx + r * np.sin(theta)
    y = cy - r * np.cos(theta)
    return [tuple(p) for p in np.column_stack((x, y))]


def draw_diamond(draw, cx, cy, radius, theta, h, w, fill_color):
    """
    Draws a radially-aligned decorative diamond marker.
    """
    mx = cx + radius * math.sin(theta)
    my = cy - radius * math.cos(theta)

    sin_t = math.sin(theta)
    cos_t = math.cos(theta)

    p1 = (mx + h * sin_t, my - h * cos_t)
    p2 = (mx + w * cos_t, my + w * sin_t)
    p3 = (mx - h * sin_t, my + h * cos_t)
    p4 = (mx - w * cos_t, my - w * sin_t)

    draw.polygon([p1, p2, p3, p4], fill=fill_color)


def get_hour_hand_points(L):
    """
    Generates local u,v coordinates for an ornate Baroque hour hand.
    """
    outer_half = [
        (-0.15 * L, 0.0),
        (-0.12 * L, 0.05 * L),
        (-0.08 * L, 0.03 * L),
        (0.0, 0.04 * L),
        (0.15 * L, 0.035 * L),
        (0.25 * L, 0.06 * L),
        (0.35 * L, 0.035 * L),
        (0.45 * L, 0.05 * L),
        (0.55 * L, 0.12 * L),
        (0.65 * L, 0.14 * L),
        (0.75 * L, 0.09 * L),
        (0.80 * L, 0.035 * L),
        (0.85 * L, 0.02 * L),
        (L, 0.0),
    ]

    outer = list(outer_half)
    for u, v in reversed(outer_half[:-1]):
        if u != outer_half[0][0]:
            outer.append((u, -v))

    # Spade internal cutout
    cutout_half = [
        (0.52 * L, 0.015 * L),
        (0.60 * L, 0.07 * L),
        (0.68 * L, 0.07 * L),
        (0.74 * L, 0.015 * L),
        (0.76 * L, 0.0),
    ]
    cutout = list(cutout_half)
    for u, v in reversed(cutout_half[:-1]):
        if u != cutout_half[0][0]:
            cutout.append((u, -v))

    return outer, [cutout]


def get_minute_hand_points(L):
    """
    Generates local u,v coordinates for an elongated Baroque minute hand.
    """
    outer_half = [
        (-0.2 * L, 0.0),
        (-0.15 * L, 0.04 * L),
        (-0.10 * L, 0.02 * L),
        (0.0, 0.03 * L),
        (0.25 * L, 0.022 * L),
        (0.32 * L, 0.05 * L),
        (0.40 * L, 0.022 * L),
        (0.48 * L, 0.022 * L),
        (0.58 * L, 0.04 * L),
        (0.68 * L, 0.09 * L),
        (0.78 * L, 0.10 * L),
        (0.85 * L, 0.05 * L),
        (0.88 * L, 0.02 * L),
        (L, 0.0),
    ]

    outer = list(outer_half)
    for u, v in reversed(outer_half[:-1]):
        if u != outer_half[0][0]:
            outer.append((u, -v))

    # Small loop cutout
    c1_half = [
        (0.30 * L, 0.012 * L),
        (0.32 * L, 0.028 * L),
        (0.34 * L, 0.028 * L),
        (0.36 * L, 0.012 * L),
        (0.37 * L, 0.0),
    ]
    c1 = list(c1_half)
    for u, v in reversed(c1_half[:-1]):
        if u != c1_half[0][0]:
            c1.append((u, -v))

    # Large spade cutout
    c2_half = [
        (0.64 * L, 0.02 * L),
        (0.70 * L, 0.05 * L),
        (0.76 * L, 0.05 * L),
        (0.81 * L, 0.02 * L),
        (0.83 * L, 0.0),
    ]
    c2 = list(c2_half)
    for u, v in reversed(c2_half[:-1]):
        if u != c2_half[0][0]:
            c2.append((u, -v))

    return outer, [c1, c2]


def generate_clock_image(config, target_size=600):
    """
    Draws the clock at a 4x upscale canvas and downsamples using LANCZOS
    to provide highly clean vector-like visual fidelity.
    """
    scale = 4
    size = target_size * scale
    cx, cy = size // 2, size // 2

    # Initialize the high-resolution transparent or colored image canvas
    img = Image.new("RGBA", (size, size), config["background_color"])
    draw = ImageDraw.Draw(img)

    bg_color = config["background_color"]
    fg_color = config["foreground_color"]
    main_color = config["main_color"]

    # -------------------------------------------------------------------------
    # 1. Outer Frame (Ornate Scalloped Border)
    # -------------------------------------------------------------------------
    scallop_count = 120
    scallop_r = 16
    R_scallop = 1145
    for i in range(scallop_count):
        angle = math.radians(i * (360.0 / scallop_count))
        sx = cx + R_scallop * math.sin(angle)
        sy = cy - R_scallop * math.cos(angle)
        draw.ellipse(
            [sx - scallop_r, sy - scallop_r, sx + scallop_r, sy + scallop_r],
            fill=main_color,
        )

    # Subtract inner region of scallops to yield a clean outer scalloped edge
    draw.ellipse([cx - 1135, cy - 1135, cx + 1135, cy + 1135], fill=bg_color)

    # Ornate concentric outer rings
    draw.ellipse(
        [cx - 1125, cy - 1125, cx + 1125, cy + 1125], outline=main_color, width=12
    )
    draw.ellipse(
        [cx - 1080, cy - 1080, cx + 1080, cy + 1080], outline=fg_color, width=10
    )
    draw.ellipse(
        [cx - 1010, cy - 1010, cx + 1010, cy + 1010], outline=fg_color, width=10
    )

    # -------------------------------------------------------------------------
    # 2. Minute Track (Dots and Diamonds)
    # -------------------------------------------------------------------------
    R_mid = 1045
    for i in range(60):
        angle = math.radians(i * 6)
        if i % 5 == 0:
            draw_diamond(draw, cx, cy, R_mid, angle, h=24, w=15, fill_color=fg_color)
        else:
            mx = cx + R_mid * math.sin(angle)
            my = cy - R_mid * math.cos(angle)
            r = 6
            draw.ellipse([mx - r, my - r, mx + r, my + r], fill=main_color)

    # -------------------------------------------------------------------------
    # 3. Inner Dial Boundaries (Numerals Channels)
    # -------------------------------------------------------------------------
    draw.ellipse([cx - 980, cy - 980, cx + 980, cy + 980], outline=main_color, width=4)
    draw.ellipse([cx - 780, cy - 780, cx + 780, cy + 780], outline=main_color, width=4)
    draw.ellipse([cx - 750, cy - 750, cx + 750, cy + 750], outline=fg_color, width=10)

    # -------------------------------------------------------------------------
    # 4. Roman Numerals
    # -------------------------------------------------------------------------
    font_path = find_font_path(config["font"])
    font_size = int(size * 0.065)

    if font_path:
        font = ImageFont.truetype(font_path, font_size)
    else:
        font = ImageFont.load_default()
        print(
            "Warning: Standard font not found. Using low-resolution system default.",
            file=sys.stderr,
        )

    roman_numerals = [
        "XII",
        "I",
        "II",
        "III",
        "IIII",
        "V",
        "VI",
        "VII",
        "VIII",
        "IX",
        "X",
        "XI",
    ]
    R_num = 880

    for i, num in enumerate(roman_numerals):
        angle = math.radians(i * 30)
        num_x = cx + R_num * math.sin(angle)
        num_y = cy - R_num * math.cos(angle)

        # Exact mathematical bounding box centering
        bbox = draw.textbbox((0, 0), num, font=font)
        text_w = bbox[2] - bbox[0]
        text_h = bbox[3] - bbox[1]

        tx = num_x - (bbox[0] + text_w / 2)
        ty = num_y - (bbox[1] + text_h / 2)

        draw.text((tx, ty), num, font=font, fill=fg_color)

    # -------------------------------------------------------------------------
    # 5. Center Filigree (Rosette Layering)
    # -------------------------------------------------------------------------
    # Rosette 1 (12 petals)
    r1_points = get_rose_points_np(cx, cy, r_base=710, frequency=6)
    draw.line(r1_points, fill=main_color, width=6, joint="curve")

    # Rosette 2 (8 petals)
    r2_points = get_rose_points_np(cx, cy, r_base=450, frequency=4)
    draw.line(r2_points, fill=main_color, width=6, joint="curve")

    # Accent rings in the center
    draw.ellipse([cx - 300, cy - 300, cx + 300, cy + 300], outline=main_color, width=4)
    draw.ellipse([cx - 280, cy - 280, cx + 280, cy + 280], outline=main_color, width=4)

    # Starburst dots in the middle
    for i in range(12):
        angle = math.radians(i * 30)
        rx = cx + 580 * math.sin(angle)
        ry = cy - 580 * math.cos(angle)
        r_dot = 14
        draw.ellipse([rx - r_dot, ry - r_dot, rx + r_dot, ry + r_dot], fill=main_color)

    # -------------------------------------------------------------------------
    # 6. Hands Positioning and Calculations
    # -------------------------------------------------------------------------
    now = datetime.datetime.now()
    hour = now.hour % 12
    minute = now.minute
    second = now.second

    # Seamless linear sweep calculations for high accuracy
    angle_minute = math.radians((minute + second / 60.0) * 6.0)
    angle_hour = math.radians((hour + minute / 60.0 + second / 3600.0) * 30.0)

    # Get hand templates
    hour_outer, hour_cutouts = get_hour_hand_points(L=580)
    min_outer, min_cutouts = get_minute_hand_points(L=880)

    # Draw Hour Hand
    h_outer_rot = transform_points_np(hour_outer, angle_hour, cx, cy)
    draw.polygon(h_outer_rot, fill=fg_color)
    for cutout in hour_cutouts:
        h_cut_rot = transform_points_np(cutout, angle_hour, cx, cy)
        draw.polygon(h_cut_rot, fill=bg_color)

    # Draw Minute Hand
    m_outer_rot = transform_points_np(min_outer, angle_minute, cx, cy)
    draw.polygon(m_outer_rot, fill=fg_color)
    for cutout in min_cutouts:
        m_cut_rot = transform_points_np(cutout, angle_minute, cx, cy)
        draw.polygon(m_cut_rot, fill=bg_color)

    # -------------------------------------------------------------------------
    # 7. Center Cap (Hides the hand pivot point seamlessly)
    # -------------------------------------------------------------------------
    draw.ellipse([cx - 75, cy - 75, cx + 75, cy + 75], fill=fg_color)
    draw.ellipse([cx - 45, cy - 45, cx + 45, cy + 45], fill=main_color)
    draw.ellipse([cx - 20, cy - 20, cx + 20, cy + 20], fill=bg_color)

    # Downscale the canvas to target size
    final_img = img.resize((target_size, target_size), Image.Resampling.LANCZOS)
    return final_img


def main():
    parser = argparse.ArgumentParser(
        description="Generate a beautiful, high-quality Baroque analog clock image."
    )
    _ = parser.add_argument(
        "-c",
        "--config",
        type=str,
        default=os.path.join(os.path.basename(__file__), "style.conf"),
        help="Path to the config file containing variables (default: ~/.config/hypr/hyprlock.conf)",
    )
    _ = parser.add_argument(
        "-o",
        "--output",
        type=str,
        default="/tmp/hyprlock_clock.png",
        help="Output image path (default: /tmp/hyprlock_clock.png)",
    )
    _ = parser.add_argument(
        "-s",
        "--size",
        type=int,
        default=600,
        help="Output resolution size in pixels (default: 512)",
    )

    args = parser.parse_args()
    config = parse_config(args.config)
    clock_img = generate_clock_image(config, target_size=args.size)

    output_dir: str = os.path.dirname(os.path.abspath(args.output))
    if output_dir:
        os.makedirs(output_dir, exist_ok=True)

    clock_img.save(args.output, "PNG")


if __name__ == "__main__":
    main()
