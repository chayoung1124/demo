<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<title>Login</title>
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="description" content="">
<meta name="author" content="">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css"
	href="https://cdn.datatables.net/1.10.22/css/jquery.dataTables.css">
<!-- Custom fonts for this template-->
<link
	href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css"
	rel="stylesheet" type="text/css">
<link
	href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
	rel="stylesheet">

<!-- Custom styles for this template-->
<link href="${pageContext.request.contextPath}/css/sb-admin-2.min.css"
	rel="stylesheet">
<!-- ✅ jQuery 먼저 로딩 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script type="text/javascript" charset="utf8"
	src="https://cdn.datatables.net/1.10.22/js/jquery.dataTables.js"></script>
<script src="https://accounts.google.com/gsi/client" async defer></script>
<script>
	function onSignIn(response) {
		const id_token = response.credential;
		$.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/member/googleLogin",
			data : {
				google_token : id_token
			},
			success : function(res) {
				if (res.startsWith("success:")) {
					const memberId = res.split(":")[1];
					window.location.href = "${pageContext.request.contextPath}/member/memview?member_id=" + memberId;
				} else if (res === "not_registered") {
					alert("등록되지 않은 사용자");
				} else {
					alert("구글 로그인 실패: " + res);
				}
			}
		});
	}
</script>
<script>
	function doSubmit() {
		document.getElementById("writeAction").submit();
	}

	function goList() {
		var memberId = "${sessionScope.member_id}";

		if (!memberId || memberId === "null") {
			alert("로그인 필요");
			return;
		}

		window.location.href = "${pageContext.request.contextPath}/";
	}
</script>
</head>
<body>
<body class="bg-gradient-primary">

	<div class="container">

		<!-- Outer Row -->
		<div class="row justify-content-center">

			<div class="col-xl-10 col-lg-12 col-md-9">

				<div class="card o-hidden border-0 shadow-lg my-5">
					<div class="card-body p-0">
						<!-- Nested Row within Card Body -->
						<div class="row">
							<div class="col-lg-6 d-none d-lg-block bg-login-image"></div>
							<div class="col-lg-6">
								<div class="p-5">
									<div class="text-center">
										<h1 class="h4 text-gray-900 mb-4">Login</h1>
									</div>
									<form id="writeAction"
										action="${pageContext.request.contextPath}/member/login"
										method="post">
										<c:if test="${not empty error}">
											<div class="alert alert-danger">${error}</div>
										</c:if>
										<div class="form-group">
											<input type="text" class="form-control form-control-user"
												name="member_id" placeholder="Id" required>
										</div>
										<div class="form-group">
											<input type="password" class="form-control form-control-user"
												name="member_pwd" placeholder="Password" required>
										</div>
										<div class="form-group">
											<!-- <div class="custom-control custom-checkbox small">
                                                <input type="checkbox" class="custom-control-input" id="customCheck">
                                                <label class="custom-control-label" for="customCheck">Remember
                                                    Me</label>
                                            </div> -->
										</div>
										<button type="submit" class="btn btn-primary btn-user btn-block">Login</button>
										<br>

										<div id="g_id_onload"
											data-client_id="95856970087-p5bvaah65o5d4jh3666m3m8u0s9bd2gc.apps.googleusercontent.com"
											data-context="signin"
											data-login_uri="http://localhost:8080/demo/member/googleLogin"
											data-callback="onSignIn" data-auto_prompt="false"></div>

										<div class="g_id_signin" data-type="standard"
											data-size="large" data-theme="outline"
											data-text="sign_in_with" data-shape="rectangular"
											data-logo_alignment="left"></div>
										<hr>
									</form>
									<div class="text-center">
										<a class="medium"
											href="${pageContext.request.contextPath}/member/memwrite">Create an Account!</a>
									</div>
								</div>
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