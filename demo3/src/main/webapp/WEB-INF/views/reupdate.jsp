<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<title>Update Reply</title>
<jsp:include page="common/head.jsp"></jsp:include>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>
label {
	font-size: 0.8rem;
}
</style>

<script type="text/javascript">
	$(document).ready(
			function() {
				$("#updateBtn").click(function() {
					location.href = "${pageContext.request.contextPath}/reply";
				});
				$.ajax({
					url : "/reply/list",
					method : "GET",
					dataType : "json",
					success : function(result) {
						var html = "";
						result.forEach(function(item) {
							html += "<tr><td><a href='reply?reply_no="
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
				+ "${board.board_no}"; // 게시글 목록으로 이동
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
					<div class="col-lg-7 border border-primary">
						<div class="p-5">
							<div class="text-center">
								<h1 class="h4 text-gray-900 mb-4">Update Reply</h1>
							</div>

							<form id="updateForm">
								<div class="form-group">
									<label for="reply_writer">댓글 작성자</label> <input type="text"
										class="form-control form-control-user" name="reply_writer"
										value="${reply.member_name}" readonly>
								</div>
								<div class="form-group">
									<label for="reply_content">댓글 내용</label>
									<textarea id="reply_content"
										class="form-control form-control-user" name="reply_content">${reply.reply_content}</textarea>
								</div>

								<button type="button" class="btn btn-primary btn-user btn-block"
									onclick="updateReply()">Update Reply</button>
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

	<script>
		function updateReply() {
			const replyContent = $("#reply_content").val().trim();
			const replyNo = "${reply.reply_no}";
			const boardNo = "${boardNo}";

			if (replyContent === "") {
				alert("댓글 내용을 입력해주세요.");
				return;
			}

			$
					.ajax({
						type : "POST",
						url : "${pageContext.request.contextPath}/reply/reupdate",
						data : {
							reply_no : replyNo,
							board_no : boardNo,
							reply_content : replyContent
						},
						success : function(response) {
							// 수정 완료 후 게시글로 리다이렉트
							window.location.href = "${pageContext.request.contextPath}/board/view?board_no="
									+ boardNo;
						},
						error : function(xhr, status, error) {
							alert("댓글 수정을 실패했습니다.");
							console.error("댓글 수정 실패:", error);
						}
					});
		}
	</script>
</body>
</html>