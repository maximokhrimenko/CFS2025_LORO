# ===============================================================
# version 2 - add 3-fold LORO  
#Workflow diagram for spatially transferable AGB modelling
#  Update: add 3-fold LORO branch after "Rank..." + its Low-AGB t-test
#  Requires: DiagrammeR, DiagrammeRsvg, rsvg
# ===============================================================
rm(list = ls())
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
        width = 2.8,
        penwidth = 1]

  # Main pipeline nodes
  A [label = \"Derive LiDAR\\nmetrics\\n(C2, C2FR, ms)\"]
  B [label = \"Choose model\\nform\\nLinear, Sqrt & Log–log\"]
  C [label = \"Best-subset\\nselection (≤3 preds)\\nLeaps, top 500/size\"]
  D [label = \"VIF screen\\nDrop VIF > 10\"]
  E [label = \"Back-transform\\npower and Sqrt models\\n(+ bias correction)\"]
  F [label = \"LORO validation\\n4 folds → RMSE, bias\"]
  G [label = \"1-SE bias filter\\n|bias| ≤ SE per fold\"]
  H [label = \"Rank surviving\\nmodels by CV RMSE\"]
  I [label = \"Low-AGB t-test\\n17 plots < 55 Mg ha⁻¹\"]

  # New branch nodes to the right of H
  J [label = \"3-fold LORO validation\\n(3 folds → RMSE, bias)\"]
  K [label = \"Low-AGB t-test\\n(3-fold branch)\\n17 plots < 55 Mg ha⁻¹\"]

  # Edges: main flow
  A -> B -> C -> D -> F
  D -> E -> F                     [style = dashed]   // dashed = branch only for log–log
  F -> G -> H -> I

  # Edges: new right-side branch
  // horizontal jump from H to J without rank constraint (keeps J to the right of H)
  H -> J [constraint = false]
  // vertical arrow under the new 3-fold LORO
  J -> K

  // Optional: keep H and I roughly aligned with their column,
  // but allow J/K to sit slightly lower/right.
}

")

# ---- graph specification ---- v3
graph <- DiagrammeR::grViz("
digraph agb_workflow {

  graph [
    rankdir = TB,
    fontsize = 12,
    labelloc = t,
    label = \"Framework for spatially transferable LiDAR-AGB models\",
    ranksep = \"0.30 equally\",
    nodesep = 0.35
  ]

  node [
    shape = rectangle,
    style = \"rounded,filled\",
    fillcolor = \"#F2F2F2\",
    fontname = Helvetica,
    fontsize = 10,
    width = 3.0,
    penwidth = 1
  ]

  // --- Left column (main workflow) ---
  A [label = \"Derive LiDAR\\nmetrics\\n(C2, C2FR, ms)\", group = left]
  B [label = \"Choose model\\nform\\nLinear, Sqrt & Log–log\", group = left]
  C [label = \"Best-subset\\nselection (≤3 preds)\\nLeaps, top 500/size\", group = left]
  D [label = \"VIF screen\\nDrop VIF > 10\", group = left]
  E [label = \"Back-transform\\npower and Sqrt models\\n(+ bias correction)\", group = left]
  F [label = \"LORO validation\\n4 folds → RMSE, bias\", group = left]
  G [label = \"1-SE bias filter\\n|bias| ≤ SE per fold\", group = left]
  H [label = \"Rank surviving\\nmodels by CV RMSE\", group = left]
  I [label = \"Low-AGB t-test\\n17 plots < 55 Mg ha⁻¹\", group = left]

  // --- Invisible spacers for fine alignment ---
  S [label = \"\", width = 0.01, height = 0.01, shape = point, style = invis, group = left]
  T [label = \"\", width = 0.01, height = 0.01, shape = point, style = invis, group = left]

  // --- Right column (new branch) ---
  J [label = \"3-fold LORO validation\\n(3 folds → RMSE, bias)\\n1-SE bias filter\\n|bias| ≤ SE per fold\", group = right]
  K [label = \"Low-AGB t-test\\n(3-fold branch)\\n17 plots < 55 Mg ha⁻¹\", group = right]

  // --- Main flow (left column) ---
  A -> B -> C -> D -> F
  D -> E -> F [style = dashed]   // dashed = branch only for transformed forms
  F -> G -> H -> I

  // --- Create the half-step offset rows using invisible nodes ---
  H -> S [style = invis, weight = 8]     // H above spacer S
  S -> I [style = invis, weight = 8]     // S above I
  I -> T [style = invis, weight = 6]     // T slightly below I

  // --- Align J/K with spacer ranks (half-step below H/I) ---
  { rank = same; S; J }
  { rank = same; T; K }

  // --- Visible edges for the right branch ---
  H -> J [constraint = false, minlen = 3]   // angled arrow (right + down)
  J -> K                                   // vertical arrow

  // --- Keep columns visually straight ---
  H -> I [style = invis, weight = 10]      // keep left column straight
  J -> K [style = invis, weight = 10]      // keep right column straight
}
")



# ---- view in RStudio Viewer ----
print(graph)

# ---- export high-resolution graphics (SVG -> PNG/PDF) ----
svg_raw <- DiagrammeRsvg::export_svg(graph)

# Save SVG to disk
svg_file <- "AGB_workflow_v2.svg"
writeLines(svg_raw, svg_file)

# PNG export (single-column ~85 mm ≈ 2010 px @ 600 dpi)
png_file <- "AGB_workflow_v2_600dpi.png"
rsvg::rsvg_png(
  svg = svg_file,
  file = png_file,
  width = 2010
)

# PDF export (vector)
pdf_file <- "AGB_workflow_v2.pdf"
rsvg::rsvg_pdf(svg_file, file = pdf_file)

message("Saved: ", png_file, "  and  ", pdf_file)
