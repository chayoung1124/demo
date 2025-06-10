<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<title>Update Board</title>
<jsp:include page="common/head.jsp"></jsp:include>
<link rel="stylesheet"
	href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.48.4/codemirror.min.css" />
<style>
label {
	font-size: 0.8rem;
}
</style>
<style>
.toastui-editor-dark{
	background-color: #e6ebfb;
	color: #c9d1d9;
}

.toastui-editor-dark .toastui-editor-contents{
	background-color: #e6ebfb;
	color: #c9d1d9;
}

.toastui-editor-dark .ProseMirror{
	background-color: #e6ebfb;
	color: #c9d1d9;
}

.toastui-editor-dark .toastui-editor-toolbar{
	background-color: #2d2d2d;
}

.toastui-editor-dark .toastui-editor-toolbar-icons{
	color: #c9d1d9;
}
</style>

<style>
.custom-file-label{
	background-color: #e6ebfb;
	color: #858796;
	border: 1px solid #d1d3e2;
}
</style>
<script type="text/javascript">
	$(document).ready(
			function() {
				$("#board_title").focus();
				$("#updateBtn").click(function() {
					location.href = "${pageContext.request.contextPath}/board";
				});
				$.ajax({
					url : "${pageContext.request.contextPath}/board/list",
					method : "GET",
					dataType : "json",
					success : function(result) {
						var html = "";
						result.forEach(function(item) {
							html += "<tr><td><a href='${pageContext.request.contextPath}/board/view?board_no="+ item.board_no + "'>" + item.board_title+ "</a></td></tr>";
						});
						$("#listArea").html(html); // 리스트를 새로 채움
						$('#example').DataTable();
					}
				});

				$("#writeAction").validate({
					rules : {
						board_title : {
							required : true
						},
						board_content : "required"
					},

					messages : {
						board_title : "제목 입력",
						board_content : "내용 입력"
					}
				});
			});
</script>
<script>
	function doSubmit() {
		document.getElementById("writeAction").submit(); // form을 전송
	}

	function goList() {
		window.location.href = "${pageContext.request.contextPath}/board"; // 게시글 목록으로 이동
	}
</script>
</head>

<body id="page-top">
	
	<%@ page import="java.net.URLEncoder" %>
	<%
		String encodedFileName = "";
		String originalFileName = "";
		
		if (request.getAttribute("board") != null) {
			com.example.demo.model.BoardVo boardVo = (com.example.demo.model.BoardVo) request.getAttribute("board");
			if (boardVo.getFile_name() != null) {
				encodedFileName = URLEncoder.encode(boardVo.getFile_name(), "UTF-8");
				int idx = boardVo.getFile_name().indexOf("_");
				if(idx != -1){
					originalFileName = boardVo.getFile_name().substring(idx+1);
				} else{
					originalFileName = boardVo.getFile_name();
				}
			}
		}
	%>
	<%
		String encodedImageName = "";
		String originalImageName = "";
		
		if(request.getAttribute("board") != null){
			com.example.demo.model.BoardVo boardVo = (com.example.demo.model.BoardVo) request.getAttribute("board");
			if(boardVo.getImage_name() != null){
				encodedImageName = URLEncoder.encode(boardVo.getImage_name(), "UTF-8");
				int i = boardVo.getImage_name().indexOf("_");
				if(i != -1){
					originalImageName = boardVo.getImage_name().substring(i+1);
				} else{
					originalImageName = boardVo.getImage_name();
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

				<div
					class="container vh-100 d-flex justify-content-center align-items-start row">
					<div class="col-lg-5 d-none d-lg-block bg-register-image"></div>
					<div class="col-lg-7 border border-primary bg-white">
						<div class="p-5">
							<div class="text-center">
								<h1 class="h4 text-gray-900 mb-4">Update Board</h1>
							</div>

							<form id="writeAction"
								action="${pageContext.request.contextPath}/board/update"
								method="post" enctype="multipart/form-data">
								<table style="display: none;">
									<tr>
										<td>번호</td>
										<input type="hidden" name="board_no" value="${board.board_no}">
									</tr>
								</table>

								<div class="form-group">
									<label for="board_title">제목</label> <input type="text"
										class="form-control form-control-user" name="board_title"
										value="${board.board_title}">
								</div>
								<div class="form-group">
									<label for="board_writer">작성자</label> <input type="text"
										class="form-control form-control-user" name="board_writer"
										value="${board.member_name}" readonly>
								</div>
								
								<%-- <c:if test="${not empty board.image_name}">
									<img src="${pageContext.request.contextPath}/board/image/${board.image_path}/${board.image_name}"
										alt="IMAGE" style="max-width:100%; margin-top:10px;">
								</c:if> --%>
								
								<div class="form-group">
									<label for="board_content">내용</label>
									<div id="contents"></div>
									<input type="hidden" name="image_name" id="image_name">
									<input type="hidden" name="image_path" id="image_path">
									<textarea name="board_content" id="board_content" style="display: none;">${board.board_content}
									</textarea>
									<textarea id="editorHTML" style="display: none;">${board.board_content}
									<c:if test="${not empty board.image_name}">
									<img src="${pageContext.request.contextPath}/board/image/${board.image_path}/${board.image_name}"
										alt="IMAGE" style="max-width:100%; margin-top:10px;">
								</c:if></textarea>
								</div>
								<div class="form-group d-flex align-items-center">
									<div class="custom-file flex-grow-1">
										<input type="file" class="custom-file-input" name="uploadFile" id="file_name">
										<label for="file_name" class="custom-file-label">
											<c:choose>
												<c:when test="${not empty board.file_name}">
													<%= originalFileName %>
												</c:when>
												<c:otherwise>
													첨부파일
												</c:otherwise>
											</c:choose>
										</label>
										<input type="hidden" name="origin_file_name" value="${board.file_name}">
									</div>
									<button type="button" id="delete_file" name="delete_file" value="false"
										class="btn btn-outline-danger ml-2" style="white-space: nowrap;">x</button>
									<input type="hidden" id="delete_file_hidden" name="delete_file" value="false">
								</div>
								<div class="form-group">
									<label for="open_yn">공개 여부</label> <label> <input
										type="radio" name="open_yn" value="1"
										${board.open_yn == '1' ? 'checked' : ''}>공개 &nbsp;
									</label> <label> <input type="radio" name="open_yn" value="0"
										${board.open_yn == '0' ? 'checked' : ''}>비공개
									</label>
								</div>
								<button type="submit" class="btn btn-primary btn-user btn-block">
									Update Board</button>
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
	
	
	
	<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
	<script>
		const editor = new toastui.Editor({
			el : document.querySelector("#contents"),
			height : "500px",
			initialEditType : "WYSIWYG",
			previewStyle : "vertical",
			initialValue : '',
			theme: "dark",
			events: {
				change: function(){
					console.log(editor.getMarkdown());
			  	}
			},
			hooks: {
				  addImageBlobHook: function (blob, callback) {
				      const formData = new FormData();
				      formData.append('image', blob);

				      fetch('${pageContext.request.contextPath}/board/uploadImage', {
				        method: 'POST',
				        body: formData
				      })
				        .then(res => res.json())
				        .then(data => {
				          if (data.success === 1) {
				            callback(data.file.url, 'image');
				            
				            document.getElementById("image_name").value = data.file.name;
				            document.getElementById("image_path").value = data.file.path;
				          } else {
				            alert(data.message || '이미지 업로드 실패');
				          }
				        })
				        .catch(() => {
				          alert('이미지 업로드 실패: 서버 오류');
				        });
				    }
			  }

		});
		//editor.setHTML(document.getElementById("board_content").value);
		//editor.setMarkdown(document.getElementById("board_content").value);
		const rawHTML = document.getElementById("editorHTML").value.trim();
		editor.setHTML(rawHTML);
		
		document.getElementById("writeAction").addEventListener("submit", function(e) {
			const title = document.querySelector('input[name="board_title"]').value;
			const content = editor.getHTML();
			const xssPattern = /<script.*?>.*?<\/script>|javascript:/gi;
			
			if(xssPattern.test(title)||xssPattern.test(content)){
				alert("XSS 공격이 감지되었습니다. 다시 작성해주세요."); 
				e.preventDefault();
				return false;
			}
			
			document.getElementById("board_content").value = content;
			document.querySelector("#contents").classList.add("toastui-editor-dark");
		});
	</script>
	
	<script>
	$(document).ready(function(){
		$("#file_name").on('change', function(){
			var fileName= $(this).val().split('\\').pop();
			$(this).next('.custom-file-label').html(fileName);
		});
		$("#delete_file").on('click', function(){
			if(confirm("파일을 삭제하시겠습니까?")){
				$("#file_name").val("");
				$("#file_name").next('.custom-file-label').html("첨부파일");
				$("#delete_file_hidden").val("true");
			}
		});
	});
	
</script>
</body>
</html>