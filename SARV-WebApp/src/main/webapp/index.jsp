<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="weka.core.converters.CSVLoader"%>
<%@ page import="weka.associations.FPGrowth"%>
<%@ page import="weka.core.Instances"%>
<%@ page import="weka.core.converters.ArffSaver"%>
<%@ page import="weka.core.converters.ConverterUtils.DataSource"%>
<%@ page import="weka.filters.Filter"%>
<%@ page import="weka.filters.supervised.attribute.NominalToBinary"%>
<%@ page import="weka.filters.unsupervised.attribute.NumericToBinary"%>
<%@ page import="weka.filters.unsupervised.attribute.NumericToNominal"%>
<%@ page import="java.io.BufferedWriter"%>
<%@ page import="java.io.FileWriter"%>
<%@ page import="java.io.ObjectOutputStream"%>
<%@ page import="java.io.FileOutputStream"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.io.File"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weka.core.json.JSONNode"%>
<%@ page import="java.util.HashSet"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.regex.Pattern"%>
<%@ page import="java.util.regex.Matcher"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="com.google.gson.GsonBuilder"%>
<%@ page import="com.mv.Entry"%>
<%@ page import="com.mv.details"%>
<%@ page import="java.util.Collections"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="java.util.List"%>
<%@ page import="java.io.IOException"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Simple Association Rules Visualizer</title>
<!--<link rel="stylesheet" href="//code.jquery.com/ui/1.13.0/themes/base/jquery-ui.css">-->
<link rel="stylesheet" href="/resources/demos/style.css">
<link rel="stylesheet" href="style.css">
<link rel="stylesheet" href="modal.css">
<link rel="stylesheet" href="containerDrag.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Sarabun&display=swap"
	rel="stylesheet">
<script src="https://d3js.org/d3.v4.min.js"></script>
<script>
d3v4 = d3;
window.d3 = null;
</script>
<script src="https://d3js.org/d3.v7.min.js"></script>


<!--<script src="https://code.jquery.com/jquery-3.6.0.js"></script>-->
<!--<script src="https://code.jquery.com/ui/1.13.0/jquery-ui.js"></script>-->
</head>
<body>

	<!-- Header -->
	<header class="top-header" id="myHeader">
		<a class="menu-item main-item">Simple Association Rules Visualizer</a>
		<a class="menu-item sub-item" id="modalButton"
			style="cursor: pointer;">How to Use</a>

		<div class="menu-item sub-item dropdown">
			<a class="dropbtn">Sample Files <i class="fa fa-caret-down"></i>
			</a>
			<div class="dropdown-content">
				<a href="./examples/Sumting.csv" download>Sumting.csv</a> <a
					href="./examples/weather.csv" download>weather.csv</a>
			</div>
		</div>
		
		<a class="menu-item sub-item" onclick="goToGit()"
				style="cursor: pointer;">Github</a>
		
		<!--
		<div class="top-header-right">
			<a class="menu-item sub-item" onclick="goToGit()"
				style="cursor: pointer;">Github</a>
		</div>
		  -->

	</header>

	<!-- Modal Menu : How to use -->
	<div id="myModal" class="modal">

		<!-- Modal content -->
		<div class="modal-content">
			<div class="modal-header">
				<span class="close">&times;</span>
				<h2>Instruction</h2>
			</div>
			<div class="modal-body">
				<h3>วิธีการใช้งาน</h3>

				<hr class="line">
				<p>
					1. อัพโหลดไฟล์ประเภท csv ผ่านปุ่ม Choose File 
				</p>
				<img src="img/howtouse1.png" class="modal-image">
				<p>
					<span style="color: red">* ไฟล์ที่นำมาอัพโหลดต้องเป็นไฟล์สกุล csv แบบ Recorded Data และ มีขนาดไม่เกิน 10KB เท่านั้น</span>
				</p>
				<p>
					<span style="color: red">* สามารถดาวโหลดไฟล์ตัวอย่างในการทดลองใช้ได้ผ่าน Sample Files</span>
				</p>
				
				<hr class="line">
				<p>2. ปรับค่า Support, Confidence และ จำนวน Rule</p>
				<img src="img/howtouse2.png" class="modal-image">

				<hr class="line">
				<p>3. เลือกรูปแบบแผนภาพที่จะแสดง ทางด้านขวาด้วยเมนู Select your
					graph type</p>
				<img src="img/howtouse3.png" class="modal-image">

				<hr class="line">
				<p>4. กดปุ่ม Create Graph เมื่อปรับค่าทุกอย่างเรียบร้อยหมดแล้ว</p>
				<img src="img/howtouse4.png" class="modal-image">

				<hr class="line">

				<h3 style="padding: 0px 0px 50px 0px;">การแสดงผลหน้าจอ</h3>
				<p>หลังจากกดปุ่ม Create Graph แล้วจะมีหน้าจอแสดงข้อมูลของแผนภาพ
					และ รูปแผนภาพที่เลือกไว้ขึ้นมา ซึ่งประกอบไปด้วย</p>

				<hr class="line">
				<h4>Graph Info</h4>
				<img src="img/graphInfo.png" class="modal-image">
				<p>เป็นหน้าต่างแสดงข้อมูลแผนภาพที่ผู้ใช้ได้กำหนดไว้ก่อนที่จะกดปุม
					Create Graph โดยมีข้อมูลดังนี้</p>
				<p>
					<span style="font-weight: bold;">Support Lower Bound : </span>ขอบเขตต่ำสุดที่จะแสดง
					Rule ในแผนภาพ
				</p>
				<p>
					<span style="font-weight: bold;">Support Upper Bound : </span>ขอบเขตสูงสุดที่จะแสดง
					Rule ในแผนภาพ
				</p>
				<p>
					<span style="font-weight: bold;">Minimum Confidence : </span>ค่าความน่าจะเป็นขั้นต่ำที่
					Item ชิ้นขวาของ Rule จะถูกเลือก
				</p>
				<p>
					<span style="font-weight: bold;">Rules Found : </span>จำนวน Rule
					ที่เจอจากการกำหนดค่า Support, Confidence และ จำนวน Rule
				</p>
				<p>
					<span style="font-weight: bold;">Rules Display Amount : </span>จำนวน
					Rule สูงสุดที่จะนำมาแสดงลงในแผนภาพ
				</p>
				<p>
					<span style="font-weight: bold;">Graph Type : </span>รูปแบบแผนภาพที่นำมาแสดง
				</p>

				<hr class="line">
				<h4>หน้าจอแสดงแผนภาพ</h4>
				<img src="img/graphDisplay.png" class="modal-image">
				<p>เป็นหน้าต่างแสดงผลลัพธ์ของแผนภาพที่ผู้ใช้ได้เลือกขึ้นมา
					ซึ่งแผนภาพบางรูปแบบสามารถใช้งานความสามารถพิเศษคือ</p>

				<hr class="line">

				<h4>แสดงหน้าจอแผนภาพขนาดเต็ม</h4>
				<img src="img/blob.png" class="modal-image">
				<p>เป็นปุ่มกดเพื่อเปิดหน้าต่างใหม่ที่จะแสดงหน้าจอแผนภาพในฉบับเต็มหน้าจอเพื่อความสะดวกในการดู</p>
				<img src="img/blobScreen.png" class="modal-image">
				
				<p style="color: red;">*** สามารถใช้ได้กับแผนภาพรูปแบบ Horizontal
					Tree, Radial Tree, Indented Tree และ Vertical Tree เท่านั้น ***</p>


			</div>
		</div>

	</div>
	<!-- browse csv file -->
	<%
	//
	//init support, confidence, rule size and check if these values are modified from servlet upload.
	//

	String sup_min = "0";
	String sup_max = "1";
	String conf = "0.1";
	String rule_size = "10";
	String graph_type = "Not selected yet.";

	Object sup_min_object = request.getAttribute("support-slider1");
	Object sup_max_object = request.getAttribute("support-slider2");
	Object conf_object = request.getAttribute("confidence-slider");
	Object rule_size_object = request.getAttribute("rules-slider");
	Object graph_type_object = request.getAttribute("graph-type");

	if (sup_min_object != null) {
		sup_min = sup_min_object.toString();
	}
	if (sup_max_object != null) {
		sup_max = sup_max_object.toString();
	}
	if (conf_object != null) {
		conf = conf_object.toString();
	}
	if (rule_size_object != null) {
		rule_size = rule_size_object.toString();
	}
	if (graph_type_object != null) {
		graph_type = graph_type_object.toString();
	}
	%>

	<div class="content">
		<!-- Info -->
		<!-- to tell the user about this project. -->
		<div class="info-wrapper">
			<h2 style="padding-bottom: 20px">
				Association Mining <small>using FPGrowth</small>
			</h2>
			<p>โครงงานนี้ใช้ FPGrowth จาก library ของ Weka
				ในการหากฎความสัมพันธ์</p>
			<p>
				สามารถเข้าชมเว็ปไซต์ของ Weka ได้โดยการ <a
					href="https://www.cs.waikato.ac.nz/ml/weka/" target="_blank">คลิกที่นี่</a>
			</p>
			
			<h2 style="padding-bottom: 20px; padding-top: 20px;">Quick Guide <small>สร้างแผนภาพใน 3 ขั้นตอน</small></h2>
			<p>1. เลือกไฟล์สกุล csv มาอัพโหลด</p>
			<p>2. ปรับแต่งค่าตามที่ต้องการ</p>
			<p>3. กดสร้างแผนภาพได้เลย</p>
			<p style="font-weight:bold;">* ศึกษาข้อมูลเพิ่มเติมได้ที่เมนู How to Use ด้านบน</p>
		</div>
		
		

		<form name="myform" action="fileupload" method="post"
			enctype="multipart/form-data">

			<div class="flexbox">
				<div class="support-wrapper">
					<div class="padding-bottom">
						<div class="icon-info">
							<img src="img/info.png"> ไฟล์ที่รับต้องเป็นไฟล์สกุล csv แบบ
							Recorded Data ขนาดไม่เกิน 10 KB
							<br>&emsp;&ensp;&nbsp;** สามารถดาวโหลดไฟล์ตัวอย่างได้ที่แถบเมนู <b>Sample Files</b> ด้านบน**
						</div>
						
						<p class="padding-top">Upload your csv file :</p>
					</div>
					<input type="file" name="myfile" accept=".csv" class="test"
						style="cursor: pointer">

					<hr class="line">

					<div class="support-values">
						<span>Support Range : </span> <span id="support-range1">
							0.05 </span> <span> - </span> <span id="support-range2"> 1 </span>
					</div>
					<div class="support-container">
						<div class="support-slider-track"></div>
						<input type="range" class="support" min="0" max="1"
							value="<%=sup_min%>" id="support-slider-1" name="support-slider1"
							step="0.05" oninput="slideOne()"> <input type="range"
							class="support" min="0" max="1" value="<%=sup_max%>"
							id="support-slider-2" name="support-slider2" step="0.05"
							oninput="slideTwo()">
					</div>

					<div class="padding-bottom">
						<div class="padding-bottom">
							<span> Confidence Value : </span> <span id="conf-value">0</span>
						</div>
						<input type="range" class="normal-slider" name="conf-slider"
							id="conf-slider" min="0.01" max="1" value="<%=conf%>" step="0.01"
							oninput="sliderConf()">
					</div>

					<div class="padding-bottom">
						<div class="padding-bottom">
							<span> Amount of Rules : </span> <span id="rules-value">1</span>
						</div>
						<input type="range" class="normal-slider" name="rules-slider"
							id="rules-slider" min="1" max="500" value="<%=rule_size%>"
							oninput="sliderRules()">
					</div>
				</div>

				<div class="graph-wrapper">

					<!-- header part : Select your graph! -->
					<div class="graph-label" style="width: 100%;">
						Select your graph type
						<hr class="line">
					</div>

					<!-- Pick up graph part -->
					<label class="graph-label"> Horizontal Tree 
					<input
						type="radio" id="graph" name="graph" value="horizontal-tree"
						checked> <img src="img/horizontal.png" class="graph-image"
						style="width: 100%;">
					</label> <label class="graph-label"> Radial Tree 
					<input
						type="radio" id="graph" name="graph" value="radial-tree">
						<img src="img/radial.png" class="graph-image" style="width: 100%;">
					</label> <label class="graph-label"> Indented Tree 
					<input
						type="radio" id="graph" name="graph" value="indented-tree">
						<img src="img/indented.png" class="graph-image"
						style="width: 100%;">
					</label> <label class="graph-label"> Vertical Tree 
					<input
						type="radio" id="graph" name="graph" value="vertical-tree">
						<img src="img/vertical.png" class="graph-image"
						style="width: 100%;">
					</label> <label class="graph-label"> Plain Text 
					<input type="radio"
						id="graph" name="graph" value="plain-text"> <img
						src="img/plain.png" class="graph-image" style="width: 100%;">
					</label> <label class="graph-label"> Table 
					<input type="radio"
						id="graph" name="graph" value="table"> <img
						src="img/table.png" class="graph-image" style="width: 100%;">
					</label>
				</div>
			</div>

			<div class="confirm-wrapper">
				<input type="submit" class="button submit" name="submit"
					value="Create Graph">
				<!--  
	    	<button onclick="location.href='.'" type="button" class="button reset" value="Reset">Reset</button>
	    	-->
			</div>

		</form>

		<script src="supportSlider.js"></script>
		<script src="slider.js"></script>
		<script src="modal.js"></script>

		<!-- display json graph -->
		<%
		/*
		String sup_min = "0";
		String sup_max = "1";
		String conf = "0.1";
		String rule_size = "250";

		Object sup_min_object = request.getAttribute("support-slider1");
		Object sup_max_object = request.getAttribute("support-slider2");
		Object conf_object = request.getAttribute("confidence-slider");
		Object rule_size_object = request.getAttribute("rules-slider");
		if(sup_min_object != null) {
			sup_min = sup_min_object.toString();
		}
		if(sup_max_object != null) {
			sup_max = sup_max_object.toString();
		}
		if(conf_object != null) {
			conf = conf_object.toString();
		}
		if(rule_size_object != null) {
			rule_size = rule_size_object.toString();
		}
		*/

		//init name,sup,conf,lift,lev,conv results
		String ruleNameResults = "";
		String supResults = "";
		String confResults = "";
		String liftResults = "";
		String levResults = "";
		String convResults = "";

		//error init
		Boolean isError = false;
		Boolean isNotFound = false;
		Boolean isFileSizeExceed = false;
		String JsonOut = "";
		String textDetailResults = "";
		Boolean isInvalidInput = false;
		String textOut = "";
		String f1 = "";
		//init line count
		String rulesFound = "";
		int count = 0;
		//String fileRequest = request.getParameter("filename");

		//get file name from absolute path
		String fileRequest = "";
		//System.out.println(System.getProperty("java.io.tmpdir"));
		if (request.getAttribute("myname") != null) {
			fileRequest = request.getAttribute("myname").toString();
		}
		
		if (request.getAttribute("invalidFileCheck=True") == "INVALID_FILE_INPUT") {
			isInvalidInput = true;
		}else if (request.getAttribute("errorCheck=True") == "FILE_SIZE_EXCEEDED") {
			isFileSizeExceed = true;
		}
		
		if (fileRequest == null) {
			
			out.println("null!");
		} else {
			
			if (fileRequest != "") {
			
				try {
			
			f1 = fileRequest;
			//out.println(f1);
			//String f1 = "C:\\Users\\User\\Desktop\\datatest\\weather.csv";
			// String f2 = "C:\\Users\\User\\Desktop\\datatest\\Market1.arff";

			String[] parts = f1.split("\\\\");
			// load CSV
			CSVLoader loader = new CSVLoader();

			loader.setSource(new File(f1));
			Instances data = loader.getDataSet();
			String fileName = parts[parts.length - 1];
			/*if(fileName.endsWith(".csv")){
				System.out.println("Luy");
			}else{
				System.out.println("Kuy");
			}*/
			
			// save ARFF
			fileName = fileName.replace("csv", "arff");
			BufferedWriter writer = new BufferedWriter(new FileWriter(fileName));
			writer.write(data.toString());
			writer.flush();
			writer.close();
			DataSource source = new DataSource(fileName);
			Instances datanew = source.getDataSet();
			//origin data
			//System.out.println(datanew);
			//String[] options = {"-R", "1"};

			//before we can use fp-growth we have to change data into binary so we had to convert the data 2 times from
			//nominal -> binary and then numeric -> binary and parse that into fpgrowth model.
			//we set class attribute from first to last
			datanew.setClassIndex(datanew.numAttributes() - 1);
			NominalToBinary nominalToBinary = new NominalToBinary(); //change data from nominal to binary.
			//nominalToBinary.setTransformAllValues(true); //change all of it.
			nominalToBinary.setInputFormat(datanew); // confirmed changing.
			//nominalToBinary.setOptions(options);
			datanew = Filter.useFilter(datanew, nominalToBinary); //filter the data with changed attributes.
			//System.out.println(datanew); //test out the new data
			NumericToBinary numericToBinary = new NumericToBinary();
			numericToBinary.setInputFormat(datanew);
			numericToBinary.setIgnoreClass(true);
			datanew = Filter.useFilter(datanew, numericToBinary);
			//System.out.println(datanew);
			NumericToNominal numericToNominal = new NumericToNominal();
			numericToNominal.setInputFormat(datanew);
			datanew = Filter.useFilter(datanew, numericToNominal);

			FPGrowth fpgModel = new FPGrowth();

			//String[] options = {"-N","250","-C","0.1","-U","1.0","-M","0.1"}; //Show all rules with default lower and upper bound mininum support.
			String[] options = {"-N", rule_size, "-C", conf, "-U", sup_max, "-M", sup_min}; //Show all rules with default lower and upper bound mininum support.
			fpgModel.setOptions(options);
			fpgModel.buildAssociations(datanew);

			//out.println("---FPGrowth---"+"\n"+"<br>"+"<br>");
			//out.println("Lower Bound Support: "+fpgModel.getLowerBoundMinSupport()+"\n"+"<br>");
			//out.println("Upper Bound Support: "+fpgModel.getUpperBoundMinSupport()+"\n"+"<br>"+"<br>");

			String fileText = fpgModel.toString();

			//Check if amount of found rules are less than max display rules
			String[] ruleCheck = fileText.split("\n");
			Integer ruleCheckNum = ruleCheck.length - 2;
			//Because somehow weka give incorrect result if max display rules are more than existing rules 
			//We restart the FPgrowth process with amount of found rules as rule_size instead to fix this issue
			if (Integer.parseInt(rule_size) > ruleCheckNum) {

				String rule_size_new = ruleCheckNum.toString();
				String[] options_restart = {"-N", rule_size_new, "-C", conf, "-U", sup_max, "-M", sup_min}; //Show all rules with default lower and upper bound mininum support.
				fpgModel.setOptions(options_restart);
				fpgModel.buildAssociations(datanew);

				fileText = fpgModel.toString();
			}

			//Create Array from text file
			String[] fileText_split = fileText.split("\n");

			String textDum2 = "";

			rulesFound = fileText_split[0];
			Pattern pattern = Pattern.compile("found\\s\\d+\\s");
			Matcher matcher = pattern.matcher(rulesFound);
			if (matcher.find()) {
				rulesFound = matcher.group(0) + "\n";

			}
			pattern = Pattern.compile("\\d+");
			matcher = pattern.matcher(rulesFound);
			if (matcher.find()) {
				rulesFound = matcher.group(0) + "\n";

			}
			//System.out.print(rulesFound); //print rulesFound;

			/*	for(int i = 0;i<fileText_split.length;i++){
					textDum2 = textDum2 + fileText_split[i].replaceAll("_binarized=\\d+", "") + "<br>";
				}
				*/
			String fileTextShowOnHtml = fileText;

			fileTextShowOnHtml = fileTextShowOnHtml.replace("<", "&lt;");
			fileTextShowOnHtml = fileTextShowOnHtml.replace(">", "&gt;");
			
			//Same as fileText_split but used for html
			String[] fileText_split2 = fileTextShowOnHtml.split("\n");

			for (int i = 0; i < fileText_split2.length; i++) {
				/*if(i==0){
					textDum2 = textDum2+fileText_split2[i].replaceAll("\\(displaying\\stop\\s\\d+\\)", "(display amount "+rule_size+")<br>");
				}else*/
				textDum2 = textDum2 + fileText_split2[i].replaceAll("_binarized=\\d+", "").replaceAll("=1", "").replaceAll("=0","") + "<br>";
			}

			//show mined text
			//out.print(textDum2);
			textOut = textDum2;

			String[] fileText_split3 = fileText.split("\n");

			String ruleName = "";

			for (int i = 2; i < fileText_split3.length; i++) {

				ruleName = ruleName + fileText_split3[i].trim() + "\n";
			}
			//System.out.println(ruleName);

			//find rule names
			pattern = Pattern.compile("\\[.+\\]");
			matcher = pattern.matcher(ruleName);
			String placeHolderString = "";
			while (matcher.find()) {
				placeHolderString = placeHolderString + matcher.group(0) + "\n";

			}

			String[] arrHolderName = placeHolderString.split("\n");//rule names

			for (int i = 0; i < arrHolderName.length; i++) {
				arrHolderName[i] = arrHolderName[i].replaceAll("_binarized=\\d+", "").replaceAll("=1", "").replaceAll("=0","")
						.replaceAll(":\\s\\d+", "");
				arrHolderName[i] = arrHolderName[i].replace("[", "");
				arrHolderName[i] = arrHolderName[i].replace("]", "");
				//System.out.println(arrHolderName[i]);
			}

			String ante = "";
			String conseq = "";
			for (String i : arrHolderName) {
				ante = ante + i.split("\\s==>\\s")[0] + "\n";
				conseq = conseq + i.split("\\s==>\\s")[1] + "\n";
			}
			String[] antecedent = ante.split("\n");
			String[] consequent = conseq.split("\n");

			//find confidence
			pattern = Pattern.compile("\\<conf:\\(.*\\)\\>");
			matcher = pattern.matcher(ruleName);
			placeHolderString = "";
			while (matcher.find()) {
				placeHolderString = placeHolderString + matcher.group(0) + "\n";

			}
			//pattern = Pattern.compile("(\\d*\\.+\\d*)|(\\d+)|(\\-\\d*\\.*\\d*)|(Infinity)|(-\\d*)");
			pattern = Pattern.compile("(?<=\\().*?(?=\\))");
			matcher = pattern.matcher(placeHolderString);
			placeHolderString = "";
			while (matcher.find()) {
				placeHolderString = placeHolderString + matcher.group(0) + "\n";

			}

			String[] arrHolderConf = placeHolderString.split("\n"); //confidence value

			//find support
			pattern = Pattern.compile("\\s*\\d*\\s*\\<");
			matcher = pattern.matcher(ruleName);
			placeHolderString = "";
			while (matcher.find()) {
				placeHolderString = placeHolderString + matcher.group(0) + "\n";

			}
			pattern = Pattern.compile("(\\d*\\.+\\d*)|(\\d+)|(\\-\\d*\\.*\\d*)|(Infinity)|(-\\d*)");
			matcher = pattern.matcher(placeHolderString);
			placeHolderString = "";
			while (matcher.find()) {
				placeHolderString = placeHolderString + matcher.group(0) + "\n";

			}

			String[] arrHolderSup = placeHolderString.split("\n"); //support value

			//find lift
			pattern = Pattern.compile("lift:\\(.+\\)\\s*l");
			matcher = pattern.matcher(ruleName);
			placeHolderString = "";
			while (matcher.find()) {
				placeHolderString = placeHolderString + matcher.group(0) + "\n";

			}

			//pattern = Pattern.compile("(\\d*\\.+\\d*)|(\\d+)|(\\-\\d*\\.*\\d*)|(Infinity)|(-\\d*)");
			pattern = Pattern.compile("(?<=\\().*?(?=\\))");
			matcher = pattern.matcher(placeHolderString);
			placeHolderString = "";
			while (matcher.find()) {
				placeHolderString = placeHolderString + matcher.group(0) + "\n";

			}
			String[] arrHolderLift = placeHolderString.split("\n"); //lift value

			//find lev
			pattern = Pattern.compile("lev:\\(.+\\)\\s*c");
			matcher = pattern.matcher(ruleName);
			placeHolderString = "";
			while (matcher.find()) {
				placeHolderString = placeHolderString + matcher.group(0) + "\n";

			}
			//pattern = Pattern.compile("(\\d*\\.+\\d*)|(\\d+)|(\\-\\d*\\.*\\d*)|(Infinity)|(-\\d*)");	
			pattern = Pattern.compile("(?<=\\().*?(?=\\))");
			matcher = pattern.matcher(placeHolderString);
			placeHolderString = "";
			while (matcher.find()) {
				placeHolderString = placeHolderString + matcher.group(0) + "\n";

			}

			String[] arrHolderLev = placeHolderString.split("\n"); //leverage value

			//find conv
			pattern = Pattern.compile("conv:\\(.+\\)\\s*");
			matcher = pattern.matcher(ruleName);
			placeHolderString = "";
			while (matcher.find()) {
				placeHolderString = placeHolderString + matcher.group(0) + "\n";

			}
			//pattern = Pattern.compile("(\\d*\\.+\\d*)|(\\d+)|(\\-\\d*\\.*\\d*)|(Infinity)|(-\\d*)");
			pattern = Pattern.compile("(?<=\\().*?(?=\\))");
			matcher = pattern.matcher(placeHolderString);
			placeHolderString = "";
			while (matcher.find()) {
				placeHolderString = placeHolderString + matcher.group(0) + "\n";

			}
			String[] arrHolderConv = placeHolderString.split("\n"); //conviction value

			/* //output check
			for(String i :arrHolderName){
				System.out.println(i);
			}
			System.out.println();
			for(String i :arrHolderSup){
				System.out.println(i);
			}
			System.out.println();
			for(String i :arrHolderConf){
				System.out.println(i);
			}
			
			System.out.println();
			for(String i :arrHolderLift){
				System.out.println(i);
			}
			System.out.println();
			for(String i :arrHolderLev){
				System.out.println(i);
			}
			System.out.println();
			for(String i :arrHolderConv){
				System.out.println(i);
			}*/

			//System.out.println(ruleName);
			//placeHolderString = matcher.group(0);

			fileText = fileText.replace("[", "");
			fileText = fileText.replace("]", "");
			
			//
			String[] fileText_split4 = fileText.split("\n");

			String textDum = "";
			String leftsideArrays = "";
			String rightsideArrays = "";

			//looping - remove ordered number from FPGrowth process
			for (int i = 2; i < fileText_split4.length; i++) {

				textDum = textDum + fileText_split4[i].replaceAll("_binarized=\\d+", "").replaceAll("=1", "").replaceAll("=0","")
						.replaceFirst("(^\\s+\\d+\\.\\s+)|(^\\d+\\.\\s+)(?!$)", "").trim() + "\n";

				//add count
				count++;

			}
			leftsideArrays = leftsideArrays.trim();
			rightsideArrays = rightsideArrays.trim();
			textDum = textDum.trim();

			String[] rules = textDum.split("\n");
			Arrays.sort(rules);
			
			//dum1 as antecedent 
			//dum2 as consequent
			String dum1 = "";
			String dum2 = "";

			for (String i : rules) {
				dum1 = dum1 + i.split(" ==> ")[0] + "\n";
				dum2 = dum2 + i.split(" ==> ")[1] + "\n";
			}

			String[] antecedentArr = dum1.split("\n");
			String[] consequentArr = dum2.split("\n");

			HashSet<String> set = new HashSet<String>();
			Entry root = new Entry("begin");
			ArrayList<String> superPump = new ArrayList<String>();
			List<String> dupListChild = new ArrayList<String>();

			Entry node = null;
			
			//Populate nodes
			for (int i = 0; i < antecedentArr.length; i++) {
				if (set.add(antecedentArr[i]) == false) {//duplicate
					dupListChild.add(consequentArr[i]);

				} else { //not duplicate
					if (node != null) {
						if (!(node.toString().equals(antecedentArr[i]))) {

							node = aMethod2form(node, dupListChild);
							root.addChild(node);
							dupListChild.clear();
						}

					}
					node = new Entry(antecedentArr[i]);
					//root.addChild(node);
					dupListChild.add(consequentArr[i]);

				}
				if (i == antecedentArr.length - 1) {
					node = new Entry(antecedentArr[i]);			
					node = aMethod2form(node, dupListChild);
					root.addChild(node);

				}

			}
			
			//Convert nodes to json
			Gson g = new GsonBuilder().setPrettyPrinting().disableHtmlEscaping().create();
			String results = g.toJson(root).toString();

			List<details> detailLists = new ArrayList<details>();

			for (int i = 0; i < arrHolderName.length; i++) {
				detailLists.add(new details(antecedent[i], consequent[i], arrHolderSup[i], arrHolderConf[i],
						arrHolderLift[i], arrHolderLev[i], arrHolderConv[i]));
				//out.println("Name: " + arrHolderName[i] + "// Sup: " + arrHolderSup[i] + "// Conf: " + arrHolderConf[i] + "// Lift: " + arrHolderLift[i] + "// Lev: " + arrHolderLev[i] + "// Conv: " + arrHolderConv[i] + "<br>");
			}
			String detailResults = g.toJson(detailLists);

			//System.out.print(detailResults);

			/*
			ruleNameResults = g.toJson(arrHolderName);
			supResults =g.toJson(arrHolderSup);
			confResults=g.toJson(arrHolderConf);
			liftResults=g.toJson(arrHolderLift);
			levResults=g.toJson(arrHolderLev);
			convResults=g.toJson(arrHolderConv);
			
			/*print json results
			System.out.println(results);*/
			JsonOut = results;
			textDetailResults = detailResults;

			//out.println(count);
			//System.out.println(request.getParameter("myInput"));
			//PrintWriter out2 = new PrintWriter(new File("C:\\Users\\User\\Desktop\\datatest\\pump.txt"));
			//out2.write(results);
			//out2.flush();
			//out2.close(); 
			
				} catch (Exception e) {
			//now give value to show in info div instead of plain output text
			//out.print("Invalid Format");
			isError = true;
				}
			} else {
				//now give value to show in info div instead of plain output text
				//out.print("File not found.");
			
				//isNotFound = true;
				 /*if(request.getAttribute("errorInvalidCheck=True") == "FILE_TYPE_INVALID" && fileRequest!=""){
					isInvalidInput = true;
				}*/
				 
			}

		}
		%>

		<%!private static Entry aMethod2form(Entry root, List<String> listofChild) {
		for (int i = 0; i < listofChild.size(); i++) {
			root.addChild(new Entry(listofChild.get(i)));
		}
		return root;
	}%>
		<script>
	/*
	const ruleNames = <%=ruleNameResults%>;
	const supportValues = <%=supResults%>;
	const confidenceValues = <%=confResults%>;
	const liftValues = <%=liftResults%>;
	const leverageValues = <%=levResults%>;
	const convictionValues = <%=convResults%>;
	
	*/
	
	</script>
		<script>var myText = <%=JsonOut%>;</script>
		<script>var textDetails = <%=textDetailResults%>;</script>
		<script>var itemCount = <%=count%>;</script>

		<!-- <script src="tidyTree.js"></script>   -->
		<!--<script src="radialDendogram.js"></script>-->
		<!--<script src="sunburst.js"></script> Sunburst doesn't compatible with non-value data.-->
		<!--<script src="indentedTree.js"></script>-->
		<!--  <script src="indentedTree.js"></script>-->

		<div class="output-wrapper">
			<!-- display error in csv -->
			<div class="output-info-wrapper" id="output-error"
				style="display: none;">
				<h2 style="color: red;">No Rules Found.</h2>
				<p style="color: red;">ไม่พบกฎความสัมพันธ์ โปรดตรวจสอบไฟล์ก่อนอัพโหลดหรือตั้งค่าแผนภาพใหม่อีกครั้ง</p>
			</div>
			<!-- display file size error -->
			<div class="output-info-wrapper" id="output-size-exceed"
				style="display: none;">
				<h2 style="color: red;">Output File Size Exceeded.</h2>
				<p style="color: red;">ไฟล์ที่อัพโหลดมีขนาดเกินกำหนด โปรดตรวจสอบไฟล์ก่อนอัพโหลดใหม่อีกครั้ง</p>
			</div>
			<!-- display file not found error -->
			<div class="output-info-wrapper" id="output-notfound"
				style="display: none;">
				<h2 style="color: red;">File Not Found.</h2>
				<p style="color: red;">ไม่พบไฟล์ โปรดอัพโหลดไฟล์</p>
			</div>
			<!-- display file invalid format -->
			<div class="output-info-wrapper" id="output-invalid"
				style="display: none;">
				<h2 style="color: red;">File Upload Error.</h2>
				<p style="color: red;">โปรดตรวจสอบไฟล์ก่อนอัพโหลดใหม่อีกครั้ง</p>
			</div>

			<div class="output-info-wrapper" id="output-info-wrapper"
				style="display: none;">
				<h1>Graph Info</h1>

				<hr class="line">

				<p>
					Support Lower Bound :
					<%=sup_min%></p>
				<p>
					Support Upper Bound :
					<%=sup_max%></p>
				<p>
					Minimum Confidence :
					<%=conf%></p>
				<p>
					Rules Found :
					<%=rulesFound%></p>
				<p>
					Rules Display Amount :
					<%=rule_size%></p>
				<p>
					Graph Type :
					<%=graph_type%></p>
			</div>
			<div class="output-container" id="output-container">
			
				<!-- blob -->
				<button id="btnBlob" style="display: none; padding: 5px; cursor:pointer;">คลิกที่นี่เพื่อแสดงแผนภาพเต็มจอ</button>
				
				<!-- graph container -->
				<div class="container" id="container" style="display: none;"></div>
				
				<!-- plain text container -->
				<div class="rules-wrapper" id="rules-content" style="display: none;">
				<%=textOut%>
				</div>
				
			</div>
		</div>
	</div>

	<!-- Select a graph function to display -->
	<%
	switch (graph_type) {
		case "horizontal-tree" :
	%>
	<script src="horizontalTree.js"></script>
	<%
	break;
	case "radial-tree" :
	%>
	<script src="radialTree.js"></script>
	<%
	break;
	case "indented-tree" :
	%>
	<script src="indentedTree.js"></script>
	<%
	break;
	case "vertical-tree" :
	%>
	<script src="verticalTree.js"></script>
	<%
	break;
	case "table" :
	%>
	<script src="table.js"></script>
	<%
	break;
	}
	%>

	<!-- Make graph container scrollable with mouse click and drag // like mobile browser -->
	<script src="containerDrag.js"></script>

	<!-- show graph info after upload + show error graph -->

	<!-- Exclusive for Horizontal, Radial, Indented and Vertical type // new graph only button will be shown -->
	<script>
	var isUpload = "<%=graph_type%>";
	
	//output error
	var error_js = <%=isError%>;
	var error = document.getElementById("output-error");
	
	//output size exceeded
	var fileSizeExceeded_js = <%=isFileSizeExceed%>;
	var fileSizeExceeded = document.getElementById("output-size-exceed");
	
	//output file not found
	var notfound_js = <%=isNotFound%>;
	var notfound = document.getElementById("output-notfound");
	
	//output invalid file
	var isInputInvalid_js = <%=isInvalidInput%>;
	var isInputInvalid = document.getElementById("output-invalid");
	
	//output - graph container / blob / vertical node / graph info
	var output = document.getElementById("container");
	var blob = document.getElementById("btnBlob");
	var info = document.getElementById("output-info-wrapper");
	//output - plain text container // because plain text used different div from graph div
	var plain_text = document.getElementById("rules-content");
	
	
	
	
	//Error File Invalid format
	if(isInputInvalid_js===true){
		isInputInvalid.style.display ="block";
	}
	//Error File Size Exceeded more than 1024*10 (10KB)
	if(fileSizeExceeded_js===true){
		fileSizeExceeded.style.display ="block";
	}
	//Error check
	else if(error_js === true && isUpload !== "Not selected yet.") {
		error.style.display ="block";
	}
	//Error file not found
	/*else if(notfound_js === true && isUpload !== "Not selected yet.") {
		notfound.style.display ="block";
	}*/
	//Check if graph type is choosen and not a plain text type --- will display graph container
	else if(isUpload !== "Not selected yet.") {
		info.style.display ="block";
		
		//check if graph type is plain text --- display plain text container
		if(isUpload === "plain-text"){
			plain_text.style.display ="block";
		}
		//graph type isnt plain text --- display graph container instead
		else{
			output.style.display ="block";	
		}
		//Show graph only button for bigger view
		//Exclude table type because graph only button can show only svg
		//
		if(isUpload !== "table" && isUpload !== "plain-text") {
			blob.style.display ="block";
		}
	}
	</script>

	<!-- header href -->
	<!-- from https://www.w3schools.com/jsref/met_win_open.asp -->
	<script>
	/* Used Modal function to display how to use page instead.
	function howToUse() {
	  window.open("howtouse.html", "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=500,left=500,width=400,height=400");
	}
	*/
	function goToGit() {
	  window.open("https://github.com/ChavaP06/SARV");
	}
	</script>
	
	<!--
	 sticky header 
	 from https://www.w3schools.com/howto/howto_js_sticky_header.asp
	-->
	<script>
	window.onscroll = function() {stickyHeader()};
	
	var header = document.getElementById("myHeader");
	var sticky = header.offsetTop;
	
	function stickyHeader() {
	  if (window.pageYOffset > sticky) {
	    header.classList.add("sticky");
	  } else {
	    header.classList.remove("sticky");
	  }
	}
	</script>

	<!-- blob tab for some people who want to see a whole d3 graph -->
	<script>
	//we need to handle a user gesture to use 'open'
	document.getElementById("btnBlob").onclick = (evt) => {
	// grab your svg element
	const svg = document.querySelector("svg");
	// convert to a valid XML source
	const as_text = new XMLSerializer().serializeToString(svg);
	// store in a Blob
	const blob = new Blob([as_text], { type: "image/svg+xml" });
	// create an URI pointing to that blob
	const url = URL.createObjectURL(blob);
	const win = open(url);
	// so the Garbage Collector can collect the blob
	win.onload = (evt) => URL.revokeObjectURL(url);
	};
	</script>

	<!-- Footer -->
	<footer class="bottom-footer">
		<b>Based on</b>
		<br>
		<a href="https://assofriend.herokuapp.com" target="_blank">https://assofriend.herokuapp.com</a>
		
		<br>
		<p style="padding-top:30px;"><span style="font-weight:bold;">Created By</span></p>
		<p>Chavanakorn Poabanzoa </p>
		<p>Witsarut Tharayot</p>
	</footer>

</body>
</html>