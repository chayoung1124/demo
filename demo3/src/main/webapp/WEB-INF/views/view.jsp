<%@page import="java.net.URLDecoder"%>
<%@page import="com.example.demo.model.BoardVo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<title>Detailed Board</title>
<jsp:include page="common/head.jsp"></jsp:include>
<link rel="stylesheet"
	href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css">
<link rel="stylesheet"
	href="https://uicdn.toast.com/editor/latest/toastui-editor-viewer.min.css">
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-viewer.min.js"></script>
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
</head>

<body id="page-top">
<%@ page import="java.net.URLEncoder"%>
<%
	String encodedFileName = "";
	String originalFileName = "";
		
	if (request.getAttribute("boardView") != null) {
		com.example.demo.model.BoardVo board = (com.example.demo.model.BoardVo) request.getAttribute("boardView");
		if (board.getFile_name() != null) {
			encodedFileName = URLEncoder.encode(board.getFile_name(), "UTF-8");
			int idx = board.getFile_name().indexOf("_");
			if(idx != -1){
				originalFileName = board.getFile_name().substring(idx+1);
			} else{
				originalFileName = board.getFile_name();
			}
		}
	}
%>

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
								<label for="board_title" class="text-primary mb-4"
									style="font-size: 40px; font-weight: bold;">${boardView.board_title}</label>
							</div>

							<table style="display: none;">
								<tr>
									<td>번호</td>
								</tr>
							</table>

							<div class="form-group">
								<label for="board_writer" style="font-weight: bold;">작성자
									- </label> ${boardView.member_name}
							</div>
							<div class="form-group">
								<label for="board_content" style="font-weight: bold;">내용</label>
								<div id="viewer"></div>
								<input type="hidden" id="board_content" value="${boardView.board_content}" />
								<input type="hidden" name="image_name" id="image_name">
								<input type="hidden" name="image_path" id="image_path">
								<textarea id="board_content" name="board_content" style="display:none;"><c:out value="${boardView.board_content}" escapeXml="false" /></textarea>
							</div>
							<div class="form-group">
								<label for="board_date" style="font-weight: bold;">작성일</label><br>
								<c:choose>
									<c:when test="${boardView.udp_date != null}">${boardView.udp_date}(수정됨)</c:when>
									<c:otherwise>${boardView.board_date}</c:otherwise>
								</c:choose>
							</div>
							<div class="form-group">
								<label for="file_name" style="font-weight: bold;">첨부파일</label><br>
								<c:choose>
									<c:when test="${not empty boardView.file_name}">
										
										<a href="${pageContext.request.contextPath}/board/file/download?fileName=<%= encodedFileName %>&filePath=${boardView.file_path}">
											<%= originalFileName %></a>
									</c:when>
									<c:otherwise>첨부된 파일이 없습니다.</c:otherwise>
								</c:choose>
								
							</div>
							<div class="form-group">
								<c:if test="${sessionScope.member_id eq boardView.board_writer}">
									<input type="button" class="btn btn-outline-primary"
										onclick="updateboard()" value="게시글 수정">
									<input type="button" class="btn btn-outline-danger"
										onclick="deleteboard()" value="삭제">
								</c:if>
								<br>
							</div>

							<hr class="border border-primary mt-4">

							<div class="border border-primary p-4 mt-4 rounded">
								<h4 class="text-primary mb-4 text-center"
									style="font-weight: bold;">Comments</h4>
								<div class="d-flex mb-3" style="gap: 10px;">
									<input type="text" id="reWrite" placeholder="댓글을 입력하세요!"
										class="form-control border border-primary text-center">
									<input type="button" value="등록" class="btn btn-primary"
										onclick="submitReply()">
								</div>
								<c:if test="${not empty replyList}">
									<c:forEach var="reply" items="${replyList}">
										<div id="reply-${reply.reply_no}"
											class="mb-3 p-3 border rounded position-relative">
											<div id="reply-content-${reply.reply_no}">
												<h5>
													<b>${reply.reply_content}</b>
												</h5>
											</div>
											<div id="reply-meta-${reply.reply_no}"
												class="text-muted small">
												- 댓글작성자 [${reply.member_name}]<br>
												<c:choose>
													<c:when test="${reply.reply_udp_date != null}">
														<fmt:formatDate value="${reply.reply_udp_date}"
															pattern="yyyy-MM-dd" /> (수정됨)
							                        </c:when>
													<c:otherwise>
														<fmt:formatDate value="${reply.reply_date}"
															pattern="yyyy-MM-dd" />
													</c:otherwise>
												</c:choose>
											</div>

											<c:if test="${sessionScope.member_id eq reply.reply_writer}">
												<div class="position-absolute"
													style="top: 10px; right: 10px;">
													<c:set var="safeContent"
														value="${fn:replace(reply.reply_content, \"'\", \"&#39;\")}" />

													<button class="btn btn-outline-primary btn-sm"
														style="font-size: 15px; padding: 2px 5px;"
														onclick="editReply(${reply.reply_no}, '${fn.escapeXml(reply.reply_content)}')">수정</button>
													<button class="btn btn-outline-danger btn-sm"
														style="font-size: 15px; padding: 2px 5px;"
														onclick="deleteReply('${reply.reply_writer}', '${reply.reply_no}')">삭제</button>
												</div>
												<div id="editForm-${reply.reply_no}" style="display: none;">
													<textarea id="editReplyContent-${reply.reply_no}"
														class="form-control mb-2">${reply.reply_content}</textarea>
													<div class="position-absolute"
														style="display: inline-block; gap: 8px; right: 10px;">
														<button class="btn btn-sm btn-primary"
															style="font-size: 15px; padding: 2px 5px;"
															onclick="submitEditReply(${reply.reply_no})">저장</button>
														<button class="btn btn-sm btn-outline-primary"
															onclick="cancelEdit(${reply.reply_no})">취소</button>
													</div>
												</div>
											</c:if>
										</div>
									</c:forEach>
								</c:if>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- End of Main Content -->
		</div>
		<!-- End of Content Wrapper -->
	</div>
	<!-- End of page Wrapper -->


	<script>
	function updateboard() {
		var sessionMemberId = "${sessionScope.member_id}";
		var boardWriter = "${boardView.board_writer}";
		
		if (sessionMemberId === boardWriter) {
			location.href = "${pageContext.request.contextPath}/board/update?board_no=" + "${boardView.board_no}";
		} else {
			alert("작성자만 수정할 수 있음");
		}
	}
	
	function deleteboard() {
		var sessionMemberId = "${sessionScope.member_id}";
		var boardWriter = "${boardView.board_writer}";

		if (sessionMemberId === boardWriter) {
			if (confirm("정말로 삭제하시겠습니까?")) {
		    	location.href = "${pageContext.request.contextPath}/board/delete?board_no=" + "${boardView.board_no}";
			}
		} else {
			alert("작성자만 삭제할 수 있습니다.");
		}
	}
</script>

	<script>
	function checkLogin() {
		const memberId = "${sessionScope.member_id}";
		
		if(!memberId){
			alert("로그인 필요");
			location.href="${pageContext.request.contextPath}/member/login";
		} else{
			location.href="${pageContext.request.contextPath}/reply/rewrite?board_no="+"${boardView.board_no}";
		}
	}
</script>

<script>
	document.getElementById("reWrite").addEventListener("keydown", function(e){
		if(e.key === "Enter" && !e.shiftKey){
			e.preventDefault();
			submitReply();
		}
	});

	function submitReply(){
		const memberId = "${sessionScope.member_id}";
		const boardNo = "${boardView.board_no}";
		const replyContent = document.getElementById("reWrite").value;
		
		if(!memberId){
			alert("로그인 필요");
			location.href = "${pageContext.request.contextPath}/member/login";
			return;
		}
		
		if(!replyContent.trim()){
			alert("댓글을 입력해주세요");
			return;
		}
		
		const xssPattern = /<script.*?>.*?<\/script>|javascript:/gi;
		if(xssPattern.test(replyContent)){
			alert("XSS 공격이 감지되었습니다. 다시 입력해주세요.");
			return;
		}
		
		$.ajax({
			type: "POST",
			url: "${pageContext.request.contextPath}/reply/rewrite",
			data:{
				reply_writer: memberId,
				board_no: boardNo,
				reply_content: replyContent
			},
			success: function(response){
				location.reload();
			},
			error: function(xhr, status, error){
				console.error("댓글 등록 실패", error);
				alert("댓글 등록을 실패했습니다");
			}
		});
	}
</script>


	<script>
	function updatereply(replyWriter, replyNo){
		var sessionMemberId = "${sessionScope.member_id}";
		var boardNo = "${boardView.board_no}";
	
   		if (sessionMemberId===replyWriter){
   			location.href="${pageContext.request.contextPath}/reply/reupdate?reply_no="+replyNo+"&board_no="+boardNo;
   		} else{
   			alert("작성자만 수정할 수 있습니다.");
   		}
	}

	function deleteReply(replyWriter, replyNo){
		var sessionMemberId = "${sessionScope.member_id}";
		var boardNo = "${boardView.board_no}";
		
		if (confirm("정말로 삭제하시겠습니까?")){
			location.href="${pageContext.request.contextPath}/reply/redelete?reply_no="+replyNo+"&board_no="+boardNo;
		} else{
			alert("작성자만 삭제할 수 있습니다.");
		}
	}
</script>

	<script>
	function editReply(replyNo, content){
	    $("[id^='editForm-']").hide();
	    $("#editReplyContent-" + replyNo).val(content);
	    $("#editForm-" + replyNo).show();
	}

	function submitEditReply(replyNo){
	    const newContent = $("#editReplyContent-" + replyNo).val().trim();
	    const boardNo = "${boardView.board_no}";
		const xssPattern = /<script.*?>.*?<\/script>|javascript:/gi;
		
		if(xssPattern.test(newContent)){
			alert("XSS 공격이 감지되었습니다. 다시 입력해주세요");
			return;
		}
		
	    if(!newContent){
	        alert("수정할 내용을 입력해주세요!");
	        return;
	    }
	
	    $.ajax({
	        type: "POST",
	        url: "${pageContext.request.contextPath}/reply/reupdate",
	        data: {
	            reply_no: replyNo,
	            reply_content: newContent,
	            board_no: boardNo
	        },
	        success: function(response){
	            alert("수정 완료");
	            location.reload();
	        },
	        error: function(xhr, status, error){
	            console.error("수정 실패 : ", error);
	            alert("수정 실패");
	        }
	    });
	}
	
	function cancelEdit(replyNo){
		$("#editForm-"+replyNo).hide();
	}
</script>

	<script>
	function updateReply(replyNo, content){
		const replyContent = document.getElementById(`reply-content-${replyNo}`);
		
		if(replyContent){
			replyContent.innerHTML = `
				<textarea id="edit-textarea-${replyNo}" class="form-control mb-2">${content}</textarea>
				<button class="btn btn-success btn-sm" onclick="saveReply(${replyNo})">Ok</button>
				<button class="btn btn-secondary btn-sm" onclick="cancelReply(${replyNo}, '${content}')">Cancel</button>
			`;
		} else{
			console.error("Reply Content element not found for replyNo:"+replyNo);
		}
	}
	
	function saveReply(replyNo){
		const newContent = document.getElementById(`edit-textarea-${replyNo}`).value;
		const boardNo = "${boardView.board_no}";
		
		if(!newContent.trim()){
			alert("댓글 내용을 입력해주세요");
			return;
		}
		
		$.ajax({
			type: "POST",
			url: "${pageContext.request.contextPath}/reply/reupdate",
			data: {
				reply_no: replyNo,
				reply_content: newContent,
				board_no: boardNo,
				reply_writer: "${sessionScope.member_id}"
			},
			success: function(response){
				document.getElementById(`reply-content-${replyNo}`).innerHTML = `<b>${newContent}</b>`;
			},
			error: function(){
				alert("댓글 수정을 실패했습니다");
			}
		});
	}
	
	function cancelReply(replyNo, originalContent){
		document.getElementById(`reply-content-${replyNo}`).innerHTML = `<b>${originalContent}</b>`;
	}
</script>



	<jsp:include page="common/footer.jsp"></jsp:include>
	<script
		src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
	<script>
	
	const ctx = '<%= request.getContextPath() %>';
	const viewer = new toastui.Editor.factory({
    	el: document.querySelector('#viewer'),
    	viewer: true,
    	useScript: true,
    	initialValue: document.getElementById("board_content").value,
    	previewStyle: 'vertical',
    	theme: "dark",
    	customHTMLRenderer: {
    		image(node) {
    			let src = node.destination;

    			if(src.startsWith('/image')) {
    				src = ctx+src;
    			}
    			
    			return [
    				{ type: 'openTag', tagName: 'img', outerNewLine: false, attributes: { src: src, alt: node.altText } },
    				{ type: 'closeTag', tagName: 'img' }
    			];
    		}
    	}
  	});
	document.querySelector("#viewer").classList.add("toastui-editor-dark");
</script>
</body>
</html>