<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<title>Write Reply</title>
<jsp:include page="common/head.jsp"></jsp:include>
<style>
label {
	font-size: 0.8rem;
}
</style>
<script type="text/javascript">
	$(document).ready(
			function() {
				$("#uploadBtn").click(function() {
					location.href = "${pageContext.request.contextPath}/reply";

				});
				$.ajax({
					url : "/reply/list",
					method : "GET",
					dataType : "json",
					success : function(result) {
						var html = "";
						result.forEach(function(item) {
							html += "<tr><td><a href='review?reply_no="
									+ item.reply_no + "'>" + item.reply_writer
									+ "</a></td></tr>";
						});
						$("#listArea").html(html); // 리스트를 새로 채움
						$('#example').DataTable();
					}
				});

			});
</script>
<script>
	function doSubmit() {
		document.getElementById("writeAction").submit(); // form을 전송
	}

	function goList() {
		window.location.href = "${pageContext.request.contextPath}/board/view?board_no="
				+ "${board.board_no}";
	}
</script>
</head>

<body id="page-top">

	<!-- Page Wrapper -->
	<div id="wrapper">

		<jsp:include page="common/sidebar.jsp"></jsp:include>

		<div id="content-wrapper" class="d-flex flex-column">

			<!-- Main Content -->
			<div id="content">

				<!-- Topbar -->
				<jsp:include page="common/header.jsp"></jsp:include>

				<div
					class="container vh-100 d-flex justify-content-center align-items-start row">
					<div class="col-lg-5 d-none d-lg-block bg-register-image"></div>
					<div class="col-lg-7 border border-primary">
						<div class="p-5">
							<div class="text-center">
								<h1 class="h4 text-gray-900 mb-4">Write Reply</h1>
							</div>

							<form id="writeAction"
								action="${pageContext.request.contextPath}/reply/rewrite"
								method="post">
								<table style="display: none;">
									<tr>
										<td>번호</td>
									</tr>
								</table>

								<div class="form-group">
									<input type="hidden" class="form-control form-control-user"
										name="board_no" value="${board.board_no}" readonly>
								</div>
								<input type="hidden" name="reply_writer"
									value="${sessionScope.member_id}">
								<div class="form-group">
									<label>댓글 작성자</label> <input type="text"
										class="form-control form-control-user" value="${memberName}"
										readonly>
								</div>
								<div class="form-group">
									<label for="reply_content">댓글 내용</label> <input type="text"
										class="form-control form-control-user" name="reply_content"
										placeholder="Content" required>
								</div>

								<button type="submit" class="btn btn-primary btn-user btn-block">
									Upload Reply</button>
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