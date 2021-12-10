var treeData = myText;

var margin = {top: 30, right: 20, bottom: 30, left: 20},
    width = window.innerWidth,
    height = 1,
    barHeight = 30,
    barWidth = window.innerWidth * 0.9;

var i = 0,
    duration = 0,
    root;

var svg = d3.select(".container").append("svg")
    .attr('width', width + margin.right + margin.left)
    .attr('height', height + margin.top + margin.bottom)
  .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
var root = d3.hierarchy(treeData) // Constructs a root node from the specified hierarchical data.
var tree = d3.tree().nodeSize([0, 30]) //Invokes tree
function update(source) {
  // Compute the flattened node list. TODO use d3.layout.hierarchy.
   nodes = tree(root); //returns a single node with the properties of d3.tree()
   nodesSort = [];
  d3.select("svg").transition()
      .duration(duration); //transition to make svg looks smoother
  // returns all nodes and each descendant in pre-order traversal (sort)
  nodes.eachBefore(function (n) {
     nodesSort.push(n);
  });
  // Compute the "layout".
  nodesSort.forEach(function (n,i) {
    n.x = i *barHeight;
  })
  // Update the nodes?
  var node = svg.selectAll("g.node")
      .data(nodesSort, function(d) { return d.id || (d.id = ++i); }); //assigning id for each node
  var nodeEnter = node.enter().append("g")
      .attr("class", "node")
      .attr("transform", function(d) {  return "translate(" + source.y + "," + source.x + ")"; })
      .style("opacity", 1e-6);
  // Enter any new nodes at the parent's previous position.
  nodeEnter.append("rect")
      .attr("y", -barHeight / 2)
      .attr("height", barHeight)
      .attr("width", barWidth)
	  .attr('stroke', '#555')
      .attr('stroke-opacity', 0.4)
      .attr('stroke-width', 1.5)
      .style("fill", color)
      .on("click", click);
  nodeEnter.append("text")
      .attr("dy", 3.5)
      .attr("dx", 5.5)
      .text(function (d) {
        return d.depth == 0 ? d.data.name + " >>>" : d.depth == 1 ? d.data.name + " >>" : d.data.name ; });
  // Transition nodes to their new position.
  nodeEnter.transition()
      .duration(duration)
      .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; })
      .style("opacity", 1);
  node.transition()
      .duration(duration)
      .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; })
      .style("opacity", 1)
    .select("rect")
      .style("fill", color);
	  
  // Transition exiting nodes to the parent's new position.
  node.exit().transition()
      .duration(duration)
      .attr("transform", function(d) { return "translate(" + source.y + "," + source.x + ")"; })
      .style("opacity", 1e-6)
      .remove();
    nodes.eachBefore(function (d) {
      d.x0 = d.x;
      d.y0 = d.y
    });
d3.select('svg').attr("height", height+(itemCount*40)+800);
}
// Initalize function
update(root);
// Toggle children on click.
function click(d) {
  if (d.children) {
    d._children = d.children;
    d.children = null;
  } else {
    d.children = d._children;
    d._children = null;
  }
  update(d);
}
function color(d) {
  return d._children ? "#3182bd" : d.children ? "#c6dbef" : "lightgreen";
}