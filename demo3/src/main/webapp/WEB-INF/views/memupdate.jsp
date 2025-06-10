<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<title>Update Member</title>
<jsp:include page="common/head.jsp"></jsp:include>
<link rel="stylesheet"
	href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css">
<style>
label {
	font-size: 0.8rem;
}
</style>
<style>
.toastui-editor-dark {
	background-color: #e6ebfb;
	color: #c9d1d9;
}

.toastui-editor-dark .toastui-editor-contents {
	background-color: #e6ebfb;
	color: #c9d1d9;
}

.toastui-editor-dark .ProseMirror {
	background-color: #e6ebfb;
	color: #c9d1d9;
}

.toastui-editor-dark .toastui-editor-toolbar {
	background-color: #2d2d2d;
}

.toastui-editor-dark .toastui-editor-toolbar-icons {
	color: #c9d1d9;
}
</style>
<script>
	function PostalCode() {
		new daum.Postcode({
			oncomplete : function(data) {
				var roadAddr = data.roadAddress;
				var jibunAddr = data.jibunAddress;
				var detailAddr = '';

				document.getElementById("postal_addr").value = data.zonecode;
				document.getElementById("road_addr").value = roadAddr;
				document.getElementById("street_addr").value = jibunAddr;

			}
		}).open();
	}
</script>
<script type="text/javascript">
	$(document).ready(function() {
		$("#updateBtn").click(function() {
			location.href = "${pageContext.request.contextPath}/member";
		});
		$.ajax({
			url : "${pageContext.request.contextPath}/member/list",
			method : "GET",
			dataType : "json",
			success : function(result) {
				var html = "";
				result.forEach(function(item) {
					html += "<tr><td><a href='${pageContext.request.contextPath}/member?member_no="+ item.member_no+ "'>"+ item.member_title+ "</a></td></tr>";
				});
				$("#listArea").html(html);
				$('#example').DataTable();
			}
		});
	});
</script>
<script>
	function doSubmit() {
		//document.getElementById("writeAction").submit();
		
		const xssPattern = /<script.*?>.*?<\/script>|javascript:/gi;
		
		const fieldcheck = [
			$("#member_id").val(),
			$("input[name='member_pwd']").val(),
			$("input[name='member_email']").val(),
			$("input[name='member_phone']").val(),
			$("input[name='member_name']").val(),
			$("#postal_addr").val(),
			$("#rode_addr").val(),
			$("#street_addr").val(),
			$("#detail_addr").val()
		];
		
		for(let field of fieldcheck){
			if(xssPattern.test(field)){
				alert("XSS 공격이 감지되었습니다. 다시 작성해주세요.");
				return false;
			}
		}
		return true;
	}

	function goList() {
		window.location.href = "${pageContext.request.contextPath}/member/memview?member_id="
				+ "${member.member_id}";
	}
</script>
</head>

<body id="page-top">

	<!-- Page Wrapper -->
	<div id="wrapper">

		<!-- Sidebar -->
		<jsp:include page="common/sidebar.jsp"></jsp:include>

		<div id="content-wrapper" class="d-flex flex-column">

			<!-- Main Content -->
			<div id="content">

				<!-- Topbar -->
				<jsp:include page="common/header.jsp"></jsp:include>

				<div
					class="container vh-100 d-flex justify-content-center align-items-start row">
					<div class="col-lg-5 d-none d-lg-block bg-register-image"></div>
					<div class="col-lg-7 border border-primary bg-white">
						<div class="p-5">
							<div class="text-center">
								<h1 class="h4 text-gray-900 mb-4">Update Member</h1>
							</div>

							<form id="writeAction"
								action="${pageContext.request.contextPath}/member/memupdate"
								method="post" onsubmit="return doSubmit();">
								<table style="display: none;">
									<tr>
										<td>번호</td>
										<input type="hidden" name="member_no"
											value="${member.member_no}">
									</tr>
								</table>
								<div class="form-group">
									<label for="member_id">ID</label> <input type="text"
										class="form-control form-control-user" name="member_id"
										value="${member.member_id}" readonly>
								</div>
								<div class="form-group">
									<label for="member_pwd">PassWord</label> <input type="password"
										class="form-control form-control-user" name="member_pwd"
										value="${member.member_pwd}">
								</div>
								<div class="form-group">
									<label for="member_name">Name</label> <input type="text"
										class="form-control form-control-user" name="member_name"
										value="${member.member_name}">
								</div>
								<div class="form-group">
									<label for="member_email">Email</label> <input type="text"
										class="form-control form-control-user" name="member_email"
										value="${member.member_email}">
								</div>
								<div class="form-group">
									<label for="member_phone">Phone</label> <input type="text"
										class="form-control form-control-user" name="member_phone"
										value="${member.member_phone}">
								</div>
								<div class="form-group">
									<label for="member_type">Gender</label> <br> <label>
										<input type="radio" name="member_type" value="0"
										${member.member_type == '0' ? 'checked' : ''}> 남성
										&nbsp;
									</label> <label> <input type="radio" name="member_type"
										value="1" ${member.member_type == '1' ? 'checked' : ''}>
										여성
									</label>
								</div>
								<div class="form-group row">
									<div class="col-sm-6 mb-3 mb-sm-0">
										<label for="postal_addr">Postal Code</label> <input
											type="text" class="form-control form-control-user"
											name="postal_addr" id="postal_addr" placeholder="Postal Code"
											value="${member.postal_addr}" readonly>
									</div>
								</div>
								<div class="form-group">
									<label for="road_addr">Road Name Address</label> <input
										type="text" class="form-control form-control-user"
										name="road_addr" id="road_addr"
										placeholder="Road Name Address" value="${member.road_addr}"
										readonly>
								</div>
								<div class="form-group">
									<label for="street_addr">Street Address</label> <input
										type="text" class="form-control form-control-user"
										name="street_addr" id="street_addr"
										placeholder="Street Address" value="${member.street_addr}"
										readonly>
								</div>
								<div class="form-group">
									<label for="detail_addr">Detailed Address</label> <input
										type="text" class="form-control form-control-user"
										name="detail_addr" id="detail_addr"
										placeholder="Detailed Address" value="${member.detail_addr}"
										readonly>
								</div>
								<button type="submit" class="btn btn-primary btn-user btn-block">
									Update Member</button>
							</form>
						</div>
					</div>
				</div>
			</div>
			<!-- End of Main Content -->
		</div>
		<!-- End of Content Wrapper -->
	</div>
	<!-- End of page Wrapper -->

	<jsp:include page="common/footer.jsp"></jsp:include>
</body>
</html>