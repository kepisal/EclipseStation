<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Staff and Student Management</title>
<link rel="stylesheet" type="text/css"
	href="bootstrap/css/bootstrap.css">
<!-- <link rel="stylesheet" type="text/css" href="css/style.css"> -->

<!-- <script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script> -->
<script type="text/javascript" src="js/jquery-min.js"></script>
<script type="text/javascript" src="bootstrap/js/bootstrap.js"></script>
<script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
<style type="text/css">
.maincontent {
	background-color: #A4A4F0;
}

#title {
	padding: 10px;
	width: 100%;
}

option {
	height: 23px;
}

.mytb td, .mytb th {
	border: 1px solid black;
	border-collapse: collapse;
	text-align: center;
}

#title {
	text-align: center;
}

img {
	width: 20px;
}

#classlist, #universitylist, #txtinput, #statuslist {
	display: inline-block;
	margin: 10px;
}

button {
	margin: 5px;
	height: 32px
}

.stuform td {
	padding: 2px;
	border: 0px;
}
</style>
</head>
<body>
	<div class="maincontent col-sm-12">
		<div id="sheader">
			<div id="title">
				<h1>Staff and Student Management</h1>
				<h4>Ke Pisal, Class Battambong</h4>
			</div>
			<div id="classlist">
				<label>Search By Name : </label> <input type=text id=txtinput /> <select
					id=classselected onclick="searchClass()">

				</select>
			</div>
			<div id="universitylist">
				<select id=unvselected onclick="searchUniversity()">

				</select>
			</div>
			<div id="statuslist">
				<select id=statusselected onclick="searchStatus()">
					<option value=''>All Status</option>
					<option value=1>Active</option>
					<option value=0>Deactive</option>
				</select>
			</div>
		</div>
		<div id="sform">
			<table class="stuform">
				<h3>
					<i>Student Data</i>
				</h3>
				<tr>
					<td><i>Student Id</i></td>
					<td>&nbsp;&nbsp;:<input id="txtinputid" /></td>
				</tr>
				<tr>
					<td><i>Student Name </i></td>
					<td>&nbsp;&nbsp;:<input id="txtinputname" /></td>
				</tr>
				<tr>
					<td><i>Student Gender </i></td>
					<td>&nbsp;&nbsp;:<select id=txtinputgender>
							<option value="1">Male</option>
							<option value="0">Female</option>
					</select></td>
				</tr>
				<tr>
					<td><i>Student University </i></td>
					<td>&nbsp;&nbsp;:<input id="txtinputuniversity" /></td>
				</tr>
				<tr>
					<td><i>Student Class </i></td>
					<td>&nbsp;&nbsp;:<input id="txtinputclass" /></td>
				</tr>
				<tr id="statustr">
					<td><i>Student Status </i></td>
					<td>&nbsp;&nbsp;:<select id="txtinputstatus">
							<option value=1>Active</option>
							<option value=0>Deactive</option>
					</select></td>
				</tr>
				<tr>
					<td colspan="2"><input type="button" id="btnadd"
						value="submit" /></td>
				</tr>
			</table>
		</div>
		<div id="sbody">
			<table class="mytb col-sm-12">
				<thead>
					<tr>
						<th>ID</th>
						<th>NAME</th>
						<th>GENDER</th>
						<th>UNIVERSITY</th>
						<th>CLASS</th>
						<th>STATUS</th>
						<th>OPERATION</th>
					</tr>
				</thead>
				<tbody id="tblist">
				</tbody>
			</table>
		</div>
		<div class="col-sm-3"></div>
	</div>
	<script type="text/javascript" src="js/script.js"></script>
</body>
</html>