/**
 * 
 */
function graphPreview() {
	var selectBox = document.getElementById("graph");
	var selectedValue = selectBox.options[selectBox.selectedIndex].value;

	switch (selectedValue) {
		case "horizontal-tree":
			document.getElementById('previewImage').src = 'img/horizontaltree.png'
			break;
		case "radial-tree":
			document.getElementById('previewImage').src = 'img/pump2.png'
			break;
		case "indented-tree":
			document.getElementById('previewImage').src = 'img/pump3.png'
			break;
		case "vertical-tree":
			document.getElementById('previewImage').src='img/pump4.png'
			break;
		case "plain-text":
			document.getElementById('previewImage').src = 'img/pump5.png'
			break;
		default:
			document.getElementById('previewImage').src = 'img/pump1.png'
	}
	//alert(selectedValue);
}
graphPreview();