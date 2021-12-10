var treeData = myText;

// set the dimensions and margins of the diagram
var margin = {top: 40, right: 90, bottom: 50, left: 90},
    width = itemCount * 20,
    height = 0;
	if(itemCount<10){
		height = 600;
	}else{
		height = (1.05*itemCount)+200;
	}
// declares a tree layout and assigns the size
var treemap = d3.tree()
    .size([width, height]);

//  assigns the data to a hierarchy using parent-child relationships
var nodes = d3.hierarchy(treeData);

// maps the node data to the tree layout
nodes = treemap(nodes);

// append the svg obgect to the body of the page
// appends a 'group' element to 'svg'
// moves the 'group' element to the top left margin
var svg = d3.select(".container").append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom),
    g = svg.append("g")
      .attr("transform",
            "translate(" + 0 + "," + margin.top + ")");
	
yDistanceMult = 0;
if(itemCount<10){
	yDistanceMult=1;
}else{
	yDistanceMult=2;
}
// adds the links between the nodes
var link = g.selectAll(".link")
    .data( nodes.descendants().slice(1))
  .enter().append("path")
    .attr("class", "link")
    .attr("d", function(d) {
       return "M" + d.x*5 + "," + d.y*yDistanceMult
         + "C" + d.x*5 + "," + ((d.y + d.parent.y) / 2)*yDistanceMult
         + " " + d.parent.x*5 + "," +  ((d.y + d.parent.y) / 2)*yDistanceMult
         + " " + d.parent.x*5 + "," + d.parent.y*yDistanceMult;
       })
	.attr("fill","none")
	.attr("stroke","#ccc")
	.attr("stroke-width","2px");
if(itemCount>10){
	d3.select('svg').attr("width", width+itemCount+80*itemCount+500);
	d3.select('svg').attr("height", height+itemCount+(1.05*itemCount)+800);
}else{
	d3.select('svg').attr("width", width+itemCount+150*itemCount+500);
	d3.select('svg').attr("height", height+itemCount+10*itemCount+500);
}


// adds each node as a group
var node = g.selectAll(".node")
    .data(nodes.descendants())
  .enter().append("g")
    .attr("class", function(d) { 
      return "node" + 
        (d.children ? " node--internal" : " node--leaf"); })
    .attr("transform", function(d) { 
      return "translate(" + d.x*5 + "," + d.y*yDistanceMult + ")"; })
	/*.on("mouseover", function(d) {
		var g = d3.select(this);
		var info = g.append('text')
					.classed('info',true)
					.attr('x', 0)
        			.attr('y', 40)
        			.text(function(d) { return d.data.name; })
	})
	.on("mouseout", function() {
      // Remove the info text on mouse out.
      d3.select(this).select('text.info').remove()
	
    })*/;
	
// adds the circle to the node
node.append("circle")
  .attr("r", 5)
  .attr("fill", function(d) { return d.children ? "#555" : "#999"; })
  .attr("stroke-width","1px")
  ;
// adds the text to the node
node.append("text")
  .attr("dy", ".35em")
  //.attr("y", function(d) { return d.children ? 0 : 0; })
  .attr("x", function(d) { return d.children ? 10 : 10; })
  .style("text-anchor", "left")
  .attr("transform","rotate(25)")
  .style("font-size",'18px')
  .text(function(d) { return d.data.name; });
  
var text = d3.selectAll("text").attr("opacity",1);

//align d3 to center
d3.select(".container").attr("align","center");

  