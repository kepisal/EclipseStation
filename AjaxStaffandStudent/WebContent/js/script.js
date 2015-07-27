$(document).ready(function() {
	lists(); // list all objects in table
	droplist(); // list all objects in dropdownlist(class, university)
	$("#txtinput").keyup(function() {
		searchName(); // action keyup on textbox
	});
	$("#btnadd").click(function() {
		add();
	});
});
/*
 * @param : data is JSon generate <option> value </option> for dropdownlist
 * class
 */
function classlist(data) {
	var str = "";
	str += "<option value=''>All Classes</option>;";
	for (var i = 0; i < data.length; i++) {
		str += "<option value=" + data[i].classes + ">" + data[i].classes;
	}
	str += "</option>";
	return str;
}
/*
 * @param : data is JSon generate <option> value </option> for dropdownlist
 * university
 */
function unvlist(data) {
	var str = "";
	str += "<option value=''>All University</option>;";
	for (var i = 0; i < data.length; i++) {
		str += "<option value=" + data[i].unversity + ">" + data[i].unversity;
	}
	str += "</optiont>";
	return str;
}

/*
 * get data from url and put into function with param
 */
function droplist() {
	$.post("classlist.hrd", function(data) {
		$("#classselected").html(classlist(data));
	});
	$.post("universitylist.hrd", function(data) {
		$("#unvselected").html(unvlist(data));
	});
}
/*
 * generate rows inside table list
 */
function lists() {
	$.post("listobject.hrd", function(data) {
		droplist();
		$("#tblist").html(listobjectdetails(data));
	});

}
/*
 * create tag <tr><td> value </td></tr> follow data
 */
function listobjectdetails(data) {
	var str = "";
	for (var i = 0; i < data.length; i++) {

		str += "<tr>" + "<td id=studid" + i + ">" + data[i].stuid + "</td>"
				+ "<td>" + data[i].stuname + "</td>" + "<td>"
				+ checkGender(data[i].gender) + "</td>" + "<td>"
				+ data[i].unversity + "</td>" + "<td>" + data[i].classes
				+ "</td>" + "<td>" + checkStatus(data[i].status, i) + "</td>"
				+ "<td><button class=btnEdit" + i + " onclick=editFun(" + i
				+ ")>Edit</button><button class=btnRemove" + i
				+ " onclick=removeFun(" + i
				+ ")>Remove</button><button class=btnView" + i
				+ " onclick=viewFun(" + i + ")>View</button></tr>";
	}

	str += "</table>";

	return str;
}

/*
 * change value 0,1 to male and female
 */
function checkGender(data) {
	var gender;
	if (data == 1) {
		gender = "Male";
	} else {
		gender = "Female";
	}
	return gender;
}
/*
 * change value 0,1 to image 0.png and 1.png
 */
function checkStatus(data, i) {
	var img;
	if (data == 0) {
		img = "<a href=javascript:void(0);><img src=img/0.png id=mydata" + i
				+ " onclick=updateStatus(" + i + "," + data + ")></a>";
	} else {
		img = "<a href=javascript:void(0); ><img src=img/1.png id=mydata" + i
				+ " onclick=updateStatus(" + i + "," + data + ")></a>";
	}
	return img;
}
/*
 * @param : id, value id -> id of each students value -> value of status update
 * status
 */
function updateStatus(id, value) {
	var stuid = $("#studid" + id).text();
	var active;
	if (value == 0) {
		active = 1;
	} else {
		active = 0;
	}
	$.post("editobject.hrd", {
		stu_id : stuid,
		stu_status : active
	}, function(data) {
		searchStatus();
	});
}
/*
 * search by name()
 */
function searchName() {
	var stuname = $('#txtinput').val();
	var stuclass = $('#classselected option:selected').val();
	var stuuniver = $('#unvselected option:selected').val();
	var stustatus = $('#statusselected option:selected').val();
	if (stuname == '') {
		lists();
	}
	$.post("searchobject.hrd", {
		stu_name : stuname,
		stu_class : stuclass,
		stu_university : stuuniver,
		stu_status : stustatus
	}, function(data) {
		$("#tblist").html(listobjectdetails(data));
	});
}
/*
 * search by class()
 */
function searchClass() {
	var stuname = $('#txtinput').val();
	var stuclass = $('#classselected option:selected').val();
	var stuuniver = $('#unvselected option:selected').val();
	var stustatus = $('#statusselected option:selected').val();
	$.post("searchobject.hrd", {
		stu_name : stuname,
		stu_class : stuclass,
		stu_university : stuuniver,
		stu_status : stustatus
	}, function(data) {
		$("#tblist").html(listobjectdetails(data));

	});
}
/*
 * search by university()
 */
function searchUniversity() {
	var stuname = $('#txtinput').val();
	var stuclass = $('#classselected option:selected').val();
	var stuuniver = $('#unvselected option:selected').val();
	var stustatus = $('#statusselected option:selected').val();
	$.post("searchobject.hrd", {
		stu_name : stuname,
		stu_class : stuclass,
		stu_university : stuuniver,
		stu_status : stustatus
	}, function(data) {
		$("#tblist").html(listobjectdetails(data));
	});
}
/*
 * search by status()
 */
function searchStatus() {
	var stuname = $('#txtinput').val();
	var stuclass = $('#classselected option:selected').val();
	var stuuniver = $('#unvselected option:selected').val();
	var stustatus = $('#statusselected option:selected').val();
	$.post("searchobject.hrd", {
		stu_name : stuname,
		stu_class : stuclass,
		stu_university : stuuniver,
		stu_status : stustatus
	}, function(data) {
		$("#tblist").html(listobjectdetails(data));
	});
}
/*
 * Add Function
 */
function add() {
	var stuid = $("#txtinputid").val();
	var stuname = $("#txtinputname").val();
	var stugender = $("#txtinputgender option:selected").val();
	var stuuniversity = $("#txtinputuniversity").val();
	var stuclass = $("#txtinputclass").val();
	var stustatus = $("#txtinputstatus option:selected").val();
	if (stuid == "" && stuname == "" && stuuniversity == "") {
		alert("Data not valid");
	} else {
		$.post("addobject.hrd", {
			stu_id : stuid,
			stu_name : stuname,
			stu_gender : stugender,
			stu_university : stuuniversity,
			stu_class : stuclass,
			stu_status : stustatus
		}, function(data) {
			lists();
			$("input").val("");
			$("#btnadd").val("Submit");
			$("#statustr").show();
		});
	}
}
/*
 * Update Object
 */
function editFun(i) {
	$("#statustr").hide();
	var stuid = $("#studid" + i).text();
	$.post("viewobject.hrd", {
		stu_id : stuid
	}, function(data) {
		$("#txtinputid").val(data.stuid);
		$("#txtinputname").val(data.stuname);
		$("#txtinputgender").val(data.gender);
		$("#txtinputuniversity").val(data.unversity);
		$("#txtinputclass").val(data.classes);
		$("#txtinputstatus").val(data.status);
		/* Change Button */
		$("#btnadd").attr("value", "update").click(function() {
			add();
		});
	});
}
/*
 * Remove Specific Object
 */
function removeFun(i) {
	var stuid = $("#studid" + i).text();
	$.post("deleteobject.hrd", {
		stu_id : stuid
	}, function(data) {
		lists();
	});
}
/*
 * View Object Details
 */
function viewFun(i) {
	var stuid = $("#studid" + i).text();
	$.post("viewobject.hrd", {
		stu_id : stuid
	}, function(data) {
		/*
		 * $("#stuid").text(data.stuid); $("#stuname").text(data.stuname);
		 * $("#stugender").text(data.gender);
		 * $("#stuuniversity").text(data.unversity);
		 * $("#stuclass").text(data.classes); $("#stustatus").text(data.status);
		 */
		alert("<<--Student Information-->>"
				+ "\n"
				+ "User ID : "
				+ data.stuid
				+ "\n"
				+ "User Name : "
				+ data.stuname
				+ "\n"
				+ "Gender : "
				+ (data.gender > 0 ? "Male" : "Female")
				+ "\n"
				+ "University : "
				+ data.unversity
				+ "\n"
				+ "Class : "
				+ data.classes
				+ "\n"
				+ "Status : "
				+ (data.status > 0 ? "Active" : "Deactive" + "\n"
						+ "<<--Student Information-->>"));
	});
}
