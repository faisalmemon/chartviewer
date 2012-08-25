chartviewer
===========

ChartViewer to allow simple charts to be viewed on an iPad

ChartViewer shows graphs, pie charts and bar charts.
For pie charts, landscape mode shows an accompanying data table.

Future enhancements:

1. Sharpening zoom:
Need to switch to tiled layer drawing for geometry.  Since this makes
it a multithreaded system, also need to switch to CATextLayer for labels.
To avoid text showing aliased (no SPAA available for CATextLayer), an
adaptive algorithm needs to be introduced to re-introduce text layers
with a content size (i.e. the bitmap size of the rendered text) set to
the level of zoom.

2. Better rotation support:
When rotating the pie chart, it will show scaled (non-aspect preserving)
during the rotation.  Need a solution for this; maybe no animation?
