<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
<title>Detailed Reply</title>
<jsp:include page="common/head.jsp"></jsp:include>
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

				<!-- Begin Page Content -->
				<div class="container-fluid">

					<!-- Page Heading -->
					<h1 class="h3 mb-2 text-gray-800">Detailed Reply</h1>
					<p class="mb-4">댓글 상세입니당</p>

					<!-- DataTales Example -->
					<div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">Detailed Reply</h6>
						</div>
						<div class="card-body">
							<div class="table-responsive">
								<table class="table table-bordered" id="dataTable" width="100%"
									cellspacing="0">
									<thead>
										<tr>
											<th>Board No</th>
											<th>Writer</th>
											<th>Content</th>
											<th>Date</th>
										</tr>
									</thead>

									<tbody>
										<tr>
											<td>${replyView.board_no}</td>
											<td>${replyView.member_name}</td>
											<td>${replyView.reply_content}</td>
											<td><c:choose>
													<c:when test="${replyView.reply_udp_date != null}">
														<fmt:formatDate value="${replyView.reply_udp_date}"
															pattern="yyyy-MM-dd" /> (수정됨)
                									</c:when>
													<c:otherwise>
														<fmt:formatDate value="${replyView.reply_date}"
															pattern="yyyy-MM-dd" />
													</c:otherwise>
												</c:choose></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
				<!-- /.container-fluid -->
			</div>
			<!-- End of Main Content -->
		</div>
		<!-- End of Content Wrapper -->
	</div>
	<!-- End of page Wrapper -->

	<jsp:include page="common/footer.jsp"></jsp:include>

</body>
</html>