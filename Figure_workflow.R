# ===============================================================
#  Workflow diagram for spatially transferable AGB modelling
#  Author: <your name>     Date: <yyyy-mm-dd>
#  Requires: DiagrammeR, DiagrammeRsvg, rsvg
# ===============================================================

# ---- libraries ----
if (!requireNamespace("DiagrammeR", quietly = TRUE)) install.packages("DiagrammeR")
if (!requireNamespace("DiagrammeRsvg", quietly = TRUE)) install.packages("DiagrammeRsvg")
if (!requireNamespace("rsvg", quietly = TRUE)) install.packages("rsvg")

library(DiagrammeR)
library(DiagrammeRsvg)  # convert to SVG
library(rsvg)           # render SVG as PNG/PDF

# ---- graph specification ----
graph <- DiagrammeR::grViz("
digraph agb_workflow {

  graph [rankdir = TB, fontsize = 12,
         labelloc = t, label = \"Framework for spatially transferable LiDAR-AGB models\" ]

  node [shape  = rectangle,
        style  = \"rounded,filled\",
        fillcolor = \"#F2F2F2\",
        fontname = Helvetica,
        fontsize = 10,
        width = 2.6,
        penwidth = 1]

  # Nodes
  A [label = \"Derive LiDAR\\nmetrics\\n(C2, C2FR, ms)\"]
  B [label = \"Choose model\\nform\\nLinear & Log–log\"]
  C [label = \"Best-subset\\nselection (≤3 preds)\\nLeaps, top 500/size\"]
  D [label = \"VIF screen\\nDrop VIF > 10\"]
  E [label = \"Back-transform\\npower models\\n(+ bias correction)\"]
  F [label = \"LORO validation\\n4 folds → RMSE, bias\"]
  G [label = \"1-SE bias filter\\n|bias| ≤ SE per fold\"]
  H [label = \"Rank surviving\\nmodels by CV RMSE\"]
  I [label = \"Low-AGB t-test\\n17 plots < 55 Mg ha⁻¹\"]
  
  # Edges
  A -> B -> C -> D -> F
  D -> E -> F                     [style = dashed]   // dashed = branch only for log–log
  F -> G -> H -> I
}

")

# ---- view in RStudio Viewer ----
print(graph)

# ---- export high-resolution graphics ----
# SVG first
svg_file <- tempfile(fileext = ".svg")
DiagrammeRsvg::export_svg(graph) %>% 
  charToRaw() %>% 
  writeBin(svg_file)

# 600-dpi PNG
png_file <- "AGB_workflow_600dpi.png"
rsvg::rsvg_png(svg_file, file = png_file, dpi = 600)

# Editable PDF
pdf_file <- "AGB_workflow.pdf"
rsvg::rsvg_pdf(svg_file, file = pdf_file)

message("Files saved: ", png_file, "  and  ", pdf_file)


# ----------------------------------------------
# export high-resolution graphics  (replaces the
# lines that triggered the 'unused argument' error)
# ----------------------------------------------

library(DiagrammeRsvg)
library(rsvg)

svg_raw <- DiagrammeRsvg::export_svg(graph)

# Save SVG to disk
svg_file <- "AGB_workflow.svg"
writeLines(svg_raw, svg_file)

# --- PNG export ---
# Target journal single-column width ~85 mm = 3.35 inches
# For 600 dpi: 3.35 * 600 ≈ 2010 pixels
png_file <- "AGB_workflow_600dpi.png"
rsvg::rsvg_png(
  svg = svg_file,
  file = png_file,
  width = 2010        # height scales automatically
)

# --- PDF export (vector, resolution-independent) ---
pdf_file <- "AGB_workflow.pdf"
rsvg::rsvg_pdf(svg_file, file = pdf_file)

message("Saved: ", png_file, "  and  ", pdf_file)
