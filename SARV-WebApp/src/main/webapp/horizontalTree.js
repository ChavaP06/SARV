
var data = myText;

//var data = JSON.parse(value);
/*var data = {
  "name": "begin",
  "children": [
    {
      "name": "Burger_binarized=1: 5",
      "children": [
        {
          "name": "Cheese_binarized=1: 2   <conf:(0.4)> lift:(0.96) lev:(-0.01) conv:(0.73)"
        },
        {
          "name": "Shrimp=1, Cheese_binarized=1: 2   <conf:(0.4)> lift:(1.6) lev:(0.06) conv:(0.94)"
        },
        {
          "name": "Shrimp=1: 5   <conf:(1)> lift:(1.2) lev:(0.07) conv:(0.83)"
        }
      ]
    },
    {
      "name": "Cheese_binarized=1, Burger_binarized=1: 2",
      "children": [
        {
          "name": "Shrimp=1: 2   <conf:(1)> lift:(1.2) lev:(0.03) conv:(0.33)"
        }
      ]
    },
    {
      "name": "Cheese_binarized=1: 5",
      "children": [
        {
          "name": "Burger_binarized=1: 2   <conf:(0.4)> lift:(0.96) lev:(-0.01) conv:(0.73)"
        },
        {
          "name": "Shrimp=1, Burger_binarized=1: 2   <conf:(0.4)> lift:(0.96) lev:(-0.01) conv:(0.73)"
        },
        {
          "name": "Shrimp=1: 3   <conf:(0.6)> lift:(0.72) lev:(-0.1) conv:(0.28)"
        }
      ]
    },
    {
      "name": "Shrimp=1, Burger_binarized=1: 5",
      "children": [
        {
          "name": "Cheese_binarized=1: 2   <conf:(0.4)> lift:(0.96) lev:(-0.01) conv:(0.73)"
        }
      ]
    },
    {
      "name": "Shrimp=1, Cheese_binarized=1: 3",
      "children": [
        {
          "name": "Burger_binarized=1: 2   <conf:(0.67)> lift:(1.6) lev:(0.06) conv:(0.88)"
        }
      ]
    },
    {
      "name": "Shrimp=1: 10",
      "children": [
        {
          "name": "Burger_binarized=1: 5   <conf:(0.5)> lift:(1.2) lev:(0.07) conv:(0.97)"
        },
        {
          "name": "Cheese_binarized=1, Burger_binarized=1: 2   <conf:(0.2)> lift:(1.2) lev:(0.03) conv:(0.93)"
        },
        {
          "name": "Cheese_binarized=1: 3   <conf:(0.3)> lift:(0.72) lev:(-0.1) conv:(0.73)"
        }
      ]
    }
  ]
}
;*/
const margin = { top: 10, right: 120, bottom: 10, left: 40 };
var width = 1024;
var height = window.innerHeight;

const root = d3.hierarchy(data);
const dx = height/width*50;	
const dy = width / 3.5;
const tree = d3.tree().nodeSize([dx, dy]);
const diagonal = d3
  .linkHorizontal()
  .x((d) => d.y)
  .y((d) => d.x);

root.x0 = dy / 2;
root.y0 = 0;
root.descendants().forEach((d, i) => {
  d.id = i;
  d._children = d.children;
  // if (d.depth && d.data.name.length !== 7) d.children = null;
});

tree(root);

const svg = d3
  .select(".container")
  .append("svg")
  .attr("width", width + margin.right + margin.left)
  .attr("height", height + margin.top + margin.bottom)
  .style("font", "12px sans-serif")
  .style("user-select", "none");

const gLink = svg
  .append("g")
  .attr("fill", "none")
  .attr("stroke", "#555")
  .attr("stroke-opacity", 0.4)
  .attr("stroke-width", 1.5);

const gNode = svg
  .append("g")
  .attr("cursor", "pointer")
  .attr("pointer-events", "all");

update(root);

function update(source) {
  const duration = d3.event && d3.event.altKey ? 2500 : 250;
  const nodes = root.descendants().reverse();
  const links = root.links();

  // Compute the new tree layout.

  let left = root;
  let right = root;
  root.eachBefore((node) => {
    if (node.x < left.x) left = node;
    if (node.x > right.x) right = node;
  });

  const height = right.x - left.x + margin.top + margin.bottom;

  const transition = svg
    .transition()
    .duration(duration)
    .attr("viewBox", [-margin.left, left.x - margin.top, width, height])
    .tween(
      "resize",
      window.ResizeObserver ? null : () => () => svg.dispatch("toggle")
    );

  // Update the nodes…
  const node = gNode.selectAll("g").data(nodes, (d) => d.id);

  // Enter any new nodes at the parent's previous position.
  const nodeEnter = node
    .enter()
    .append("g")
    .attr("transform", (d) => `translate(${source.y0},${source.x0})`)
    .attr("fill-opacity", 0)
    .attr("stroke-opacity", 0)
    /*.on("click", (event, d) => {
      d.children = d.children ? null : d._children;
      update(d);
    })*/;

  nodeEnter
    .append("circle")
    .attr("r", 2.5)
    .attr("fill", (d) => (d._children ? "#555" : "#999"))
    .attr("stroke-width", 10);

  nodeEnter
    .append("text")
    .attr("dy", "0.31em")
    .attr("x", (d) => (d._children ? -6 : 6))
    .attr("text-anchor", (d) => (d._children ? "end" : "start"))
    .text((d) => d.data.name)
    .clone(true)
    .lower()
    .attr("stroke-linejoin", "round")
    .attr("stroke-width", 3)
    .attr("stroke", "white");

  // Transition nodes to their new position.
  node
    .merge(nodeEnter)
    .transition(transition)
    .attr("transform", (d) => `translate(${d.y},${d.x})`)
    .attr("fill-opacity", 1)
    .attr("stroke-opacity", 1);

  // Transition exiting nodes to the parent's new position.
  node
    .exit()
    .transition(transition)
    .remove()
    .attr("transform", (d) => `translate(${source.y},${source.x})`)
    .attr("fill-opacity", 0)
    .attr("stroke-opacity", 0);

  // Update the links…
  const link = gLink.selectAll("path").data(links, (d) => d.target.id);

  // Enter any new links at the parent's previous position.
  const linkEnter = link
    .enter()
    .append("path")
    .attr("d", (d) => {
      const o = { x: source.x0, y: source.y0 };
      return diagonal({ source: o, target: o });
    });

  // Transition links to their new position.
  link.merge(linkEnter).transition(transition).attr("d", diagonal);

  // Transition exiting nodes to the parent's new position.
  link
    .exit()
    .transition(transition)
    .remove()
    .attr("d", (d) => {
      const o = { x: source.x, y: source.y };
      return diagonal({ source: o, target: o });
    });

  // Stash the old positions for transition.
  root.eachBefore((d) => {
    d.x0 = d.x;
    d.y0 = d.y;
  });
d3.select('svg').attr("width", width+itemCount+500).attr("height", height+itemCount+500);

}

/*
var treeData = {
  name: "Top Level",
  children: [
    {
      name: "Level 2: A",
      children: [
        {
          name: "Son of A",
        },
        {
          name: "Daughter of A",
        },
      ],
    },
    {
      name: "Level 2: B",
    },
  ],
};

var margin = { top: 20, right: 90, bottom: 20, left: 90 };
var width = 960 - margin.left - margin.right;
var height = 500 - margin.top - margin.bottom;

var svg = d3
  .select(".container")
  .append("svg")
  .attr("width", width + margin.right + margin.left)
  .attr("height", height + margin.top + margin.bottom)
  .append("g")
  .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

var i = 0;
var duration = 750;
var root;

var treemap = d3.tree().size([height, width]);
root = d3.hierarchy(treeData, function (d) {
  return d.children;
});
root.x0 = height / 2;
root.y0 = 0;
console.log("root ", root);

update(root);

function update(source) {
  var treeData = treemap(root);

  // nodes
  var nodes = treeData.descendants();
  nodes.forEach(function (d) {
    d.y = d.depth * 180;
  });
  var node = svg.selectAll("g.node").data(nodes, function (d) {
    return d.id || (d.id = ++i);
  });
  var nodeEnter = node
    .enter()
    .append("g")
    .attr("class", "node")
    .attr("transform", function (d) {
      return "translate(" + source.y0 + ", " + source.x0 + ")";
    })
    .on("click", click);

  nodeEnter
    .append("circle")
    .attr("class", "node")
    .attr("r", 0)
    .style("fill", function (d) {
      return d._children ? "red" : "#fff";
    });
   nodeEnter
	.append('text')
	.attr('dy','.35em')
	.attr('x',function(d){
		return d.children || d._children ? -13 : 13;
	})
	.attr('text-anchor',function(d){
		return d.children || d._children ? 'end' : 'start';
	})
	.text(function(d){
		return d.data.name;
	})
  var nodeUpdate = nodeEnter.merge(node);

  nodeUpdate
    .transition()
    .duration(duration)
    .attr("transform", function (d) {
      return "translate(" + d.y + ", " + d.x + ")";
    });

  nodeUpdate
    .select("circle.node")
    .attr("r", 10)
    .style("fill", function (d) {
      return d._children ? "red" : "#fff";
    })
    .attr("cursor", "pointer");

  nodeExit = node
	.exit()
	.transition()
	.duration(duration)
	.attr('transform',function(d){
		return "translate("+source.y + ", "+ source.x +")"
	})
	.remove();
   nodeExit.select('circle').attr('r',0);
   nodeExit.select('text').style('fill-opacity',0);
//links
   function diagonal(s, d) {
    path = `M ${s.y} ${s.x}
      C ${(s.y + d.y) / 2} ${s.x}
        ${(s.y + d.y) / 2} ${d.x}
        ${d.y} ${d.x}`;
    return path;
  }
  var links = treeData.descendants().slice(1);
  var link = svg.selectAll("path.link").data(links, function (d) {
    return d.id;
  });
  var linkEnter = link
    .enter()
    .insert("path", "g")
    .attr("class", "link")
    .attr("d", function (d) {
      var o = { x: source.x0, y: source.y };
      return diagonal(o, o);
    });
  var linkUpdate = linkEnter.merge(link);
  linkUpdate
    .transition()
    .duration(duration)
    .attr("d", function (d) {
      return diagonal(d, d.parent);
    });

  var linkExit = link
    .exit()
    .transition()
    .duration(duration)
    .attr("d", function (d) {
      var o = { x: source.x0, y: source.y0 };
      return diagonal(o, o);
    })
    .remove();

  nodes.forEach(function (d) {
    d.x0 = d.x;
    d.y0 = d.y;
  });

  function click(event, d) {
    if (d.children) {
      d._children = d.children;
      d.children = null;
    } else {
      d.children = d._children;
      d._children = null;
    }
    update(d);
  }
}*/