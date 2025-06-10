<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<title>Board List</title>

<jsp:include page="common/head.jsp"></jsp:include>

<script type="text/javascript">
	$(document).ready(function() {
		$("#writeBtn").click(function() {
			location.href = "${pageContext.request.contextPath}/board/write";
		})
		$.ajax({
			url : "${pageContext.request.contextPath}/board/list",
			cache : false,
			success : function(result) {
				var html = "";
				result.forEach(function(item) {
					html += "<tr> <td><a href='${pageContext.request.contextPath}/board/view?board_no="+ item.board_no + "'>"+ item.board_title+ "</a></td></tr>";
				});
				$("#listArea").html(html); // append → html()로 변경하여 목록 초기화 후 다시 추가
				$('#example').DataTable();
			}
		});
	});

	function goViewpage(board_no) {
		location.href = "${pageContext.request.contextPath}/board/view?board_no=" + board_no;
	}
</script>

<script>
	$(document).ready(function() {
		$.ajax({
			type : "GET",
			url : "${pageContext.request.contextPath}/board/list", // 게시판 목록을 가져오는 URL
			success : function(data) {
				var boardListHtml = "";
				data.forEach(function(board) {
					boardListHtml += "<tr>";
					boardListHtml += "<td>"+ board.board_no+ "</td>";
					boardListHtml += "<td><a href='${pageContext.request.contextPath}/board/view?board_no="+ board.board_no+ "'>"+ board.board_title+ "</a></td>";
					boardListHtml += "<td>"+ board.board_writer+ "</td>";
					boardListHtml += "<td>"+ board.board_date+ "</td>";
					boardListHtml += "<td>"+ board.board_content+ "</td>";
					boardListHtml += "<td><a href='${pageContext.request.contextPath}/board/update?board_no="+ board.board_no+ "'>수정</a> <a href='${pageContext.request.contextPath}/board/delete?board_no="+ board.board_no+ "'>삭제</a></td>";
					boardListHtml += "</tr>";
				});
				$("#boardList").html(boardListHtml); // 동적으로 목록을 채움
			}
		});
	});
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

		window.location.href = "${pageContext.request.contextPath}/member/memview?member_id="+ memberId;
	}
</script>

<script>
	function checkLogin(event) {
		<c:if test="${empty sessionScope.member_id}">
			alert("로그인 필요");
			location.href = "${pageContext.request.contextPath}/member/login";
		</c:if>
		<c:if test="${not empty sessionScope.member_id}">
			location.href = "${pageContext.request.contextPath}/board/write";
		</c:if>
	}
</script>

<script>
	function checkLogins(memberId, boardNo) {
		console.log("memberId", memberId);
		console.log("boardNo", boardNo);
		
		if(!memberId || memberId === "null"){
			alert("로그인 필요");
			location.href="${pageContext.request.contextPath}/member/login";
		} else{
			location.href="${pageContext.request.contextPath}/board/view?board_no="+boardNo;
		}
	}
</script>

<script>
	function checkPrivateAccess(memberId, boardNo, openYn){
		if(!memberId || memberId === "null"){
			alert("로그인 필요");
			location.href="${pageContext.request.contextPath}/member/login";
			return;
		}
		
		if(openYn == 0){
			pwdModal(boardNo);
		} else{
			location.href = "${pageContext.request.contextPath}/board/view?board_no="+boardNo;
		}
	}
</script>
</head>
<body id="page-top">
<%@ page import="java.net.URLEncoder"%>
<%
	String encodedFileName = "";
	String originalFileName = "";
		
	if (request.getAttribute("board") != null) {
		com.example.demo.model.BoardVo board = (com.example.demo.model.BoardVo) request.getAttribute("board");
		if (board.getImage_name() != null) {
			encodedFileName = URLEncoder.encode(board.getImage_name(), "UTF-8");
			int idx = board.getImage_name().indexOf("_");
			if(idx != -1){
				originalFileName = board.getImage_name().substring(idx+1);
			} else{
				originalFileName = board.getImage_name();
			}
		}
	}
%>
	<!-- Page Wrapper -->
	<div id="wrapper">

		<jsp:include page="common/sidebar.jsp"></jsp:include>

		<div id="content-wrapper" class="d-flex flex-column">

			<!-- Main Content -->
			<div id="content">

				<!-- Topbar -->
				<jsp:include page="common/header.jsp"></jsp:include>

				<!-- Begin Page Content -->
				<div class="container-fluid">

					<!-- Page Heading -->
					<h1 class="h3 mb-2 text-gray-800">Board List</h1>
					<p class="mb-4">게시글을 작성해보세요</p>
					<input type="button" value="글쓰기" class="btn btn-primary"
						onclick="checkLogin(event)">
					<hr>

					<!-- DataTales Example -->
					<div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">Board List</h6>
						</div>
						<div class="card-body">
							<div class="table-responsive">
								<table class="table table-bordered" id="dataTable" width="100%"
									cellspacing="0">
									<thead>
										<tr>
											<th>No</th>
											<th>Title</th>
											<th>Writer</th>
											<th>Date</th>
											<th>Content</th>
											<th>Open Y/N</th>
											<th>Detail View</th>
										</tr>
									</thead>

									<tbody>
										<c:forEach var="board" items="${boardList}">
											<tr
												class="<c:out value='${board.notice_no == 1 ? "table-info" : ""}'/>">
												<td><c:choose>
														<c:when test="${board.notice_no == 1}">Notice</c:when>
														<c:otherwise>${board.board_no}</c:otherwise>
													</c:choose>
												</td>
												<td>${board.board_title}</td>
												<td>${board.member_name}</td>
												<td><c:choose>
														<c:when test="${board.udp_date != null}">${board.udp_date} (수정됨)</c:when>
														<c:otherwise>${board.board_date}</c:otherwise>
													</c:choose>
												</td>
												<td>
													<c:choose>
														<c:when test="${not empty board.image_name}"><%= originalFileName %>${board.board_content}</c:when>
														<c:otherwise>${board.board_content}</c:otherwise>
													</c:choose>
												</td>	
												<td><c:choose>
														<c:when test="${board.open_yn == 0}">비공개</c:when>
														<c:otherwise>공개</c:otherwise>
													</c:choose></td>
												<td>
													<button type="button" class="btn btn-outline-info"
														onclick="checkPrivateAccess('${sessionScope.member_id}', ${board.board_no}, ${board.open_yn})">
														Click!</button>
												</td>
											</tr>
										</c:forEach>
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

	<div id="passwordModal" class="modal"
		style="display: none; position: fixed; top: 30%; left: 50%; transform: translate(-30%, -10%); background: #fff; padding: 10px; width: 500px; height: 200px; border: 2px solid #info; box-shadow: 0 0 0 0.25rem rgba(13, 202, 240, 0.25); border-radius: 8px;">
		<p>
		<h4>Enter your Password</h4>
		</p>
		<input type="password" id="passwordInput" maxlength="4"
			placeholder="비밀번호 4자리 입력"
			class="form-control border border-info text-center mb-2"><br>
		<button class="btn btn-outline-info" onclick="checkPassword()">Ok</button>
		<button class="btn btn-outline-info" onclick="closeModal()">Cancel</button>
	</div>

	<script>
		let selectBoardNo = null;
		
		function pwdModal(boardNo){
			selectBoardNo = boardNo;
			document.getElementById("passwordModal").style.display="block";
			const input = document.getElementById("passwordInput");
			input.focus();
			
			input.removeEventListener("keypress", enterKeyHandler);
			input.addEventListener("keypress", enterKeyHandler);
		}
		
		function enterKeyHandler(e){
			if(e.key ==="Enter"){
				checkPassword();
			}
		}
		
		function checkPassword(){
			const password=$("#passwordInput").val();
			
			$.ajax({
				type: "POST",
				url: "${pageContext.request.contextPath}/board/checkPassword",
				data: {
					board_no: selectBoardNo,
					password: password
				},
				success: function(data){
					if(data.success){
						console.log("href:", "${pageContext.request.contextPath}/board/view?board_no="+selectBoardNo);
						sessionStorage.setItem("pw_pass_"+selectBoardNo, "true");
						location.href="${pageContext.request.contextPath}/board/view?board_no="+selectBoardNo;
					} else{
						alert("비밀번호가 틀립니다");
					}
				},
				error: function(xhr, status, error){
					console.log("error", error);
					alert("Server Error");
				}
			});
		}
		
		function closeModal(){
			document.getElementById("passwordModal").style.display="none";
			document.getElementById("passwordInput").value="";
		}
	</script>

	<jsp:include page="common/footer.jsp"></jsp:include>

</body>
</html>
