import math
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
from matplotlib import colors
from matplotlib.patches import Arc, Circle, Ellipse, FancyArrowPatch, FancyBboxPatch, Wedge


OUT_DIR = Path("figure_output") / "ugr_mechanism"
OUT_DIR.mkdir(parents=True, exist_ok=True)


BLUE = "#2878B5"
ORANGE = "#F28E2B"
RED = "#D62728"
GREEN = "#2A9D68"
DARK = "#27313A"
GRAY = "#69757F"
LIGHT = "#EEF2F4"
PURPLE = "#7B4AB5"


def setup_axis(ax, title, letter):
    ax.set_xlim(0, 1)
    ax.set_ylim(0, 1)
    ax.set_aspect("equal")
    ax.axis("off")
    ax.text(0.015, 0.975, letter, va="top", ha="left", fontsize=15, fontweight="bold")
    ax.text(0.075, 0.975, title, va="top", ha="left", fontsize=12.5, fontweight="bold", color=DARK)


def phase_disc(ax, center, radius, m, label, arrow_direction):
    n = 300
    x = np.linspace(-1, 1, n)
    y = np.linspace(-1, 1, n)
    xx, yy = np.meshgrid(x, y)
    rr = np.hypot(xx, yy)
    phi = np.arctan2(yy, xx)
    phase = np.mod(m * phi, 2 * np.pi)
    rgba = plt.get_cmap("twilight")(colors.Normalize(0, 2 * np.pi)(phase))
    rgba[..., 3] = (rr <= 1).astype(float)
    cx, cy = center
    ax.imshow(
        rgba,
        extent=(cx - radius, cx + radius, cy - radius, cy + radius),
        origin="lower",
        interpolation="bilinear",
        zorder=2,
    )
    ax.add_patch(Circle(center, radius, fill=False, edgecolor=DARK, linewidth=1.1, zorder=3))
    ax.add_patch(Circle(center, radius * 0.08, facecolor="white", edgecolor=DARK, linewidth=0.7, zorder=4))
    ax.text(cx + radius * 1.23, cy, label, va="center", fontsize=10.5, color=DARK)
    if arrow_direction > 0:
        start, end = (cx, cy + radius + 0.008), (cx, cy + radius + 0.050)
    else:
        start, end = (cx, cy - radius - 0.008), (cx, cy - radius - 0.050)
    ax.add_patch(FancyArrowPatch(start, end, arrowstyle="-|>", mutation_scale=13, lw=1.7, color=DARK))


def draw_helix(ax, x0=0.5, y0=0.5, height=0.23, width=0.105, turns=2.5):
    t = np.linspace(0, 2 * np.pi * turns, 260)
    y = y0 - height / 2 + height * t / t.max()
    x = x0 + width * np.sin(t)
    ax.plot(x, y, color=PURPLE, lw=3.0, solid_capstyle="round")
    ax.plot([x0, x0], [y0 - height / 2 - 0.02, y0 + height / 2 + 0.02], color=GRAY, lw=0.8, ls=":")
    ax.text(x0, y0, "helical\nsource", ha="center", va="center", fontsize=9.5, color=DARK,
            bbox=dict(boxstyle="round,pad=0.25", fc="white", ec="none", alpha=0.88))


def draw_normal_source_panel(ax):
    setup_axis(ax, "Reference: prescribed helical source", "a")
    phase_disc(ax, (0.42, 0.76), 0.145, +1, r"$m=+1$", +1)
    phase_disc(ax, (0.42, 0.22), 0.145, +1, r"$m=+1$", -1)
    draw_helix(ax, x0=0.42, y0=0.49)
    ax.text(0.73, 0.53, r"$q(\phi)\propto e^{+i\phi}$", ha="center", fontsize=11, color=PURPLE)
    ax.text(0.73, 0.43, "The source fixes the same\nlab-frame azimuthal order\non both sides.",
            ha="center", va="center", fontsize=9.3, color=GRAY)
    ax.text(0.50, 0.035, "Fixed global azimuthal coordinate $\\phi$", ha="center", fontsize=9, color=GRAY)


def draw_ring_layer(ax, center, width, height, rotation_deg, alpha, zorder):
    cx, cy = center
    ax.add_patch(Ellipse(center, width, height, facecolor="#DDE5E9", edgecolor=DARK,
                         linewidth=1.0, alpha=alpha, zorder=zorder))
    ax.add_patch(Ellipse(center, width * 0.55, height * 0.55, facecolor="white", edgecolor=DARK,
                         linewidth=0.9, alpha=1.0, zorder=zorder + 1))
    for angle, color, span in [(rotation_deg + 35, BLUE, 76), (rotation_deg + 145, ORANGE, 30),
                               (rotation_deg + 215, BLUE, 76), (rotation_deg + 325, ORANGE, 30)]:
        th = np.deg2rad(np.linspace(angle - span / 2, angle + span / 2, 80))
        x = cx + 0.43 * width * np.cos(th)
        y = cy + 0.43 * height * np.sin(th)
        ax.plot(x, y, color=color, lw=9.0, alpha=0.88 * alpha,
                solid_capstyle="butt", zorder=zorder + 2)
        ax.plot(x, y, color=DARK, lw=0.7, alpha=0.8, zorder=zorder + 3)


def draw_ugr_panel(ax):
    setup_axis(ax, "Point source converted by a twisted-bilayer UGR", "b")
    phase_disc(ax, (0.39, 0.79), 0.13, +1, r"$m=+1$", +1)
    phase_disc(ax, (0.39, 0.18), 0.13, -1, r"$m=-1$", -1)
    draw_ring_layer(ax, (0.39, 0.43), 0.50, 0.18, 0, 0.62, 3)
    draw_ring_layer(ax, (0.39, 0.56), 0.50, 0.18, 10, 0.92, 7)
    ax.add_patch(FancyArrowPatch((0.64, 0.49), (0.69, 0.57), connectionstyle="arc3,rad=-0.35",
                                 arrowstyle="-|>", mutation_scale=11, color=PURPLE, lw=1.4))
    ax.text(0.70, 0.55, r"twist $\theta$", fontsize=9.2, color=PURPLE)
    source_xy = (0.50, 0.55)
    ax.scatter([source_xy[0]], [source_xy[1]], s=155, marker="*", color=RED,
               edgecolor="white", linewidth=0.8, zorder=15)
    ax.annotate("monopole in\norange cavity", xy=source_xy, xytext=(0.77, 0.72),
                arrowprops=dict(arrowstyle="->", lw=1.0, color=RED),
                fontsize=9.2, color=RED, ha="center")
    ax.text(0.76, 0.35, "UGR locks propagation\ndirection to OAM sign", ha="center", va="center",
            fontsize=9.8, color=DARK,
            bbox=dict(boxstyle="round,pad=0.35", fc=LIGHT, ec="#AAB4BA", lw=0.8))
    ax.text(0.50, 0.035, r"Output pair: $(\uparrow,+m)$ and $(\downarrow,-m)$", ha="center", fontsize=9.4, color=GRAY)


def draw_phasor(ax, origin, constructive, label, channel):
    ox, oy = origin
    scale = 0.085
    ax.add_patch(Circle(origin, 0.105, fill=False, ec="#CBD2D6", lw=0.7))
    ax.add_patch(FancyArrowPatch(origin, (ox + scale, oy), arrowstyle="-|>", mutation_scale=10,
                                 lw=2.0, color=BLUE))
    if constructive:
        second_end = (ox + scale * 0.92, oy + scale * 0.08)
        result_end = (ox + scale * 1.55, oy + scale * 0.04)
        status = "constructive"
        status_color = GREEN
    else:
        second_end = (ox - scale * 0.92, oy)
        result_end = (ox + scale * 0.10, oy)
        status = "cancelled"
        status_color = RED
    ax.add_patch(FancyArrowPatch(origin, second_end, arrowstyle="-|>", mutation_scale=10,
                                 lw=2.0, color=ORANGE))
    ax.add_patch(FancyArrowPatch(origin, result_end, arrowstyle="-|>", mutation_scale=11,
                                 lw=2.5, color=status_color))
    ax.text(ox, oy + 0.14, channel, ha="center", fontsize=10.2, fontweight="bold", color=DARK)
    ax.text(ox, oy - 0.145, status, ha="center", fontsize=9.0, color=status_color)


def draw_interference_panel(ax):
    setup_axis(ax, "UGR as channel-selective interference", "c")
    draw_phasor(ax, (0.25, 0.70), True, "desired", r"$A_{\uparrow,+m}$")
    draw_phasor(ax, (0.75, 0.70), False, "suppressed", r"$A_{\uparrow,-m}$")
    draw_phasor(ax, (0.25, 0.37), False, "suppressed", r"$A_{\downarrow,+m}$")
    draw_phasor(ax, (0.75, 0.37), True, "desired", r"$A_{\downarrow,-m}$")
    ax.text(0.50, 0.175, r"$A_{s,m}=\sum_j a_j C_{j,m}\,e^{-im\phi_j}e^{-is k_z z_j}$",
            ha="center", fontsize=10.0, color=DARK)
    ax.text(0.50, 0.085, r"$\Delta\Phi_{s,m}=\Delta\varphi_{\rm res}-m\theta-s k_z\Delta z$",
            ha="center", fontsize=10.0, color=PURPLE,
            bbox=dict(boxstyle="round,pad=0.25", fc="#F6F1FA", ec="#C8B2DA", lw=0.7))
    ax.text(0.50, 0.018, "Blue and orange: the two resonant radiation paths; green: surviving channel",
            ha="center", fontsize=8.3, color=GRAY)


def rounded_box(ax, xy, w, h, text, edge, face, dashed=False, fontsize=9.4):
    box = FancyBboxPatch(xy, w, h, boxstyle="round,pad=0.02,rounding_size=0.025",
                         facecolor=face, edgecolor=edge, linewidth=1.2,
                         linestyle="--" if dashed else "-")
    ax.add_patch(box)
    ax.text(xy[0] + w / 2, xy[1] + h / 2, text, ha="center", va="center",
            fontsize=fontsize, color=DARK)
    return box


def draw_framework_panel(ax):
    setup_axis(ax, "Source-response framework and the EP question", "d")
    rounded_box(ax, (0.04, 0.64), 0.19, 0.14, "point source\n$\\mathbf{f}$", RED, "#FFF1F0")
    rounded_box(ax, (0.31, 0.64), 0.25, 0.14, "resonant response\n$(\\omega I-H_{\\rm eff})^{-1}$", PURPLE, "#F6F1FA")
    rounded_box(ax, (0.64, 0.64), 0.18, 0.14, "radiation\nmatrix $D$", BLUE, "#EEF6FB")
    rounded_box(ax, (0.86, 0.61), 0.11, 0.20, "$\\uparrow,+m$\n\n$\\downarrow,-m$", GREEN, "#EFF8F3", fontsize=8.9)
    for x0, x1 in [(0.23, 0.31), (0.56, 0.64), (0.82, 0.86)]:
        ax.add_patch(FancyArrowPatch((x0, 0.71), (x1, 0.71), arrowstyle="-|>", mutation_scale=11,
                                     lw=1.3, color=DARK))
    ax.text(0.50, 0.53, r"$\mathbf{b}=D(\omega I-H_{\rm eff})^{-1}\mathbf{f}$",
            ha="center", fontsize=12, color=DARK)
    rounded_box(ax, (0.06, 0.19), 0.36, 0.18,
                "UGR mechanism\nchannel zeros from\nradiation interference",
                GREEN, "#EFF8F3", fontsize=8.6)
    rounded_box(ax, (0.58, 0.19), 0.36, 0.18,
                "EP/Jordan (optional)\ndefective $H_{\\rm eff}$\nJordan-vector response",
                PURPLE, "#F6F1FA", dashed=True, fontsize=8.5)
    ax.add_patch(FancyArrowPatch((0.42, 0.28), (0.58, 0.28), arrowstyle="-|>", mutation_scale=11,
                                 lw=1.2, color=GRAY, linestyle="--"))
    ax.text(0.50, 0.32, "verify eigenmode\ncoalescence", ha="center", va="bottom",
            fontsize=7.8, color=GRAY)
    ax.text(0.50, 0.075, "Opposite-$m$ output proves channel selection, not an EP by itself.",
            ha="center", fontsize=8.5, color=GRAY)


def main():
    plt.rcParams.update({
        "font.family": "DejaVu Sans",
        "font.size": 10,
        "axes.linewidth": 0.8,
        "mathtext.fontset": "dejavusans",
        "svg.fonttype": "none",
    })
    fig = plt.figure(figsize=(14.6, 9.6), dpi=220, facecolor="white")
    gs = fig.add_gridspec(2, 2, left=0.035, right=0.985, top=0.93, bottom=0.055,
                          hspace=0.15, wspace=0.10)
    draw_normal_source_panel(fig.add_subplot(gs[0, 0]))
    draw_ugr_panel(fig.add_subplot(gs[0, 1]))
    draw_interference_panel(fig.add_subplot(gs[1, 0]))
    draw_framework_panel(fig.add_subplot(gs[1, 1]))
    fig.suptitle("Mechanism of opposite-OAM radiation enabled by a unidirectional guided resonance",
                 fontsize=16, fontweight="bold", color=DARK, y=0.975)
    fig.text(0.5, 0.018,
             "The azimuthal index m is defined in one fixed laboratory coordinate system on both output planes.",
             ha="center", fontsize=9.2, color=GRAY)
    for ext in ("png", "svg", "pdf"):
        fig.savefig(OUT_DIR / f"figure1_ugr_opposite_m_mechanism.{ext}", bbox_inches="tight")
    plt.close(fig)


if __name__ == "__main__":
    main()
