<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<title>Create an Account</title>
<jsp:include page="common/head.jsp"></jsp:include>
<style>
label {
	font-size: 0.8rem;
}
</style>
<script>
	function PostalCode() {
		new daum.Postcode({
			oncomplete : function(data) {
				var roadAddr = data.roadAddress || "";
				var jibunAddr = data.jibunAddress || "";

				if (!jibunAddr && data.autoJibunAddress) {
					jibunAddr = data.autoJibunAddress;
				}

				document.getElementById("postal_addr").value = data.zonecode;
				document.getElementById("road_addr").value = roadAddr;
				document.getElementById("street_addr").value = jibunAddr;

				document.getElementById("detail_addr").focus();
			}
		}).open();
	}
</script>
<script type="text/javascript">
	$(document).ready(function() {
		$("#member_id").on("input", function(){
			isIdChecked = false;
			$("#idCheckResult").html("");
		});
		
		$("#uploadBtn").click(function() {
			location.href = "${pageContext.request.contextPath}/member";
		});
		
		$.ajax({
			url : "${pageContext.request.contextPath}/member/list",
			method : "GET",
			dataType : "json",
			success : function(result) {
				var html = "";
				result.forEach(function(item) {
					html += "<tr><td><a href='${pageContext.request.contextPath}/member/memview?member_no="+ item.member_no+ "'>"+ item.member_id+ "</a></td></tr>";
				});
				$("#listArea").html(html);
				$('#example').DataTable();
			}
		});
	});
</script>
<script>
	let isIdChecked = false;

	function doSubmit() {
		//document.getElementById("writeAction").submit();
		
		if(!isIdChecked){
			alert("ID 중복검사를 해주세요.");
			return false;
		}
		
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
				alert("XSS 공격이 감지되었습니다. 다시 작성해주세요");
				return false;
			}
		}
		
		return true;
	}

	function goList() {
		window.location.href = "${pageContext.request.contextPath}/member";
	}
</script>

<script>
    function checkId() {
        var memberId = $("#member_id").val();
        if (!memberId) {
            $("#idCheckResult").html("<span style='color: red;'>ID를 입력해주세요</span>");
            isIdChecked = false;
            return;
        }

        $.ajax({
            url: "${pageContext.request.contextPath}/member/idcheck",
            type: "GET",
            data: { member_id: memberId },
            success: function(result) {
                if (result === "available") {
                    $("#idCheckResult").html("<span style='color: green;'>사용 가능한 ID입니다</span>");
                    isIdChecked = true;
                } else {
                    $("#idCheckResult").html("<span style='color: red;'>이미 사용중인 ID입니다</span>");
                    isIdChecked = false;
                }
            },
            error: function() {
                $("#idCheckResult").html("<span style='color: red;'>오류가 발생했습니다.</span>");
                isIdChecked = false;
            }
        });
    }
</script>
</head>

<body class="bg-gradient-primary">

	<div class="container">

		<div class="card o-hidden border-0 shadow-lg my-5">
			<div class="card-body p-0">
				<!-- Nested Row within Card Body -->
				<div class="row">
					<div class="col-lg-5 d-none d-lg-block bg-register-image"></div>
					<div class="col-lg-7">
						<div class="p-5">
							<div class="text-center">
								<h1 class="h4 text-gray-900 mb-4">Create an Account!</h1>
							</div>

							<form id="writeAction"
								action="${pageContext.request.contextPath}/member/memwrite"
								method="post" onsubmit="return doSubmit();">
								<table style="display: none;">
									<tr>
										<td>번호</td>
									</tr>
								</table>

								<div class="form-group row">
									<div class="col-sm-8 mb-3 mb-sm-0">
										<input type="text" class="form-control form-control-user"
											name="member_id" id="member_id" placeholder="Id" required>
									</div>
									<div class="col-sm-4">
										<button type="button" class="btn btn-success btn-user btn-block"
												onclick="checkId()">Check ID</button>
									</div>
								</div>
								<div id="idCheckResult" class="mb-3 text-sm text-gray-700"></div>
								<div class="form-group">
									<input type="password" class="form-control form-control-user"
										name="member_pwd" placeholder="Password" required>
								</div>
								<div class="form-group">
									<input type="text" class="form-control form-control-user"
										name="member_email" placeholder="Email" required>
								</div>
								<div class="form-group">
									<input type="text" class="form-control form-control-user"
										name="member_phone" placeholder="Phone" required>
								</div>
								<div class="form-group row">
									<div class="col-sm-6 mb-3 mb-sm-0">
										<input type="text" class="form-control form-control-user"
											name="member_name" placeholder="Name" required>
									</div>
									<div class="col-sm-3">
										<label for="member_type">Gender</label> &nbsp;&nbsp; <label>
											<input type="radio" name="member_type" value="0"
											${member_type=='0'?'checked':''} required>남성
										</label>
									</div>
									<div class="col-sm-3">
										<label> <input type="radio" name="member_type"
											value="1" ${member_type=='1'?'checked':''}>여성
										</label>
									</div>
								</div>
								<div class="form-group row">
									<div class="col-sm-6 mb-3 mb-sm-0">
										<input type="text" class="form-control form-control-user"
											name="postal_addr" id="postal_addr" placeholder="Postal Code"
											required>
									</div>
									<div class="col-sm-6">
										<input type="button"
											class="form-control form-control-user btn btn-info"
											onclick="PostalCode()" value="Find Address">
									</div>
								</div>
								<div class="form-group">
									<input type="text" class="form-control form-control-user"
										name="road_addr" id="road_addr"
										placeholder="road Name Address" required>
								</div>
								<div class="form-group">
									<input type="text" class="form-control form-control-user"
										name="street_addr" id="street_addr"
										placeholder="Street Address" required>
								</div>
								<div class="form-group">
									<input type="text" class="form-control form-control-user"
										name="detail_addr" id="detail_addr"
										placeholder="Detailed Address" required>
								</div>
								<button type="submit" class="btn btn-primary btn-user btn-block">
									Sign Up</button>
								<!-- <hr>
                                <a href="index.html" class="btn btn-google btn-user btn-block">
                                    <i class="fab fa-google fa-fw"></i> Register with Google
                                </a>
                                <a href="index.html" class="btn btn-facebook btn-user btn-block">
                                    <i class="fab fa-facebook-f fa-fw"></i> Register with Facebook
                                </a> -->
							</form>
							<hr>

							<div class="text-center">
								<a class="medium"
									href="${pageContext.request.contextPath}/member/login">
									Already	have an account? <b>Login!</b></a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

	</div>

	<!-- Bootstrap core JavaScript-->
	<script
		src="${pageContext.request.contextPath}/vendor/jquery/jquery.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

	<!-- Core plugin JavaScript-->
	<script
		src="${pageContext.request.contextPath}/vendor/jquery-easing/jquery.easing.min.js"></script>

	<!-- Custom scripts for all pages-->
	<script src="${pageContext.request.contextPath}/js/sb-admin-2.min.js"></script>


</body>
</html>