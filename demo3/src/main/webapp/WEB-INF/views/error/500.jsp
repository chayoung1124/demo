<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<title>500 Error Page</title>
<jsp:include page="/WEB-INF/views/common/head.jsp"></jsp:include>
</head>
<body id="page-top">

	<!-- Page Wrapper -->
	<div id="wrapper">

		<!-- Sidebar -->
		<jsp:include page="/WEB-INF/views/common/sidebar.jsp"></jsp:include>
		<!-- Content Wrapper -->
		<div id="content-wrapper" class="d-flex flex-column">

			<!-- Main Content -->
			<div id="content">

				<!-- Topbar -->
				<jsp:include page="/WEB-INF/views/common/header.jsp"></jsp:include>

				<!-- Begin Page Content -->
				<div class="container-fluid">

					<!-- 404 Error Text -->
					<div class="text-center">
						<div class="error mx-auto" data-text="500">500</div>
						<p class="lead text-gray-800 mb-5">Internal Server Error</p>
						<a href="${pageContext.request.contextPath}/">&larr; Back to
							Dashboard</a>
					</div>

				</div>
				<!-- /.container-fluid -->

			</div>
			<!-- End of Main Content -->


		</div>
		<!-- End of Content Wrapper -->

	</div>
	<!-- End of Page Wrapper -->

	<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>
</body>
</html>