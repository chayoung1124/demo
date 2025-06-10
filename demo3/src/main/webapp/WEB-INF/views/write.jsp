<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>Write Board</title>
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
	$(document).ready(function() {
		$("#board_title").focus();
	  	$("#uploadBtn").click(function(){
	    	location.href="${pageContext.request.contextPath}/board";
	    }); 
	    
	  	$.ajax({
			url: "${pageContext.request.contextPath}/board/list",
	        method: "GET",
	        dataType: "json",
	        success: function(result) {             
	            var html = "";
	            result.forEach(function(item){
	                html += "<tr><td><a href='${pageContext.request.contextPath}/board/view?board_no=" + item.board_no + "'>" + item.board_title + "</a></td></tr>";
	            });
	            $("#listArea").html(html);
	            $('#example').DataTable();
	        }
	    });

	  	$("#writeAction").validate({
	    	rules:{
	    		board_title :{required:true},
	    		board_content :"required"
	    	}, 
	    	messages:{
	    		board_title:"제목 입력",
	    		board_content:"내용 입력"
	    	}
		});
	});
</script>

<script>
   function doSubmit() {
      document.getElementById("writeAction").submit();
   }

   function goList() {
      window.location.href = "${pageContext.request.contextPath}/board";
   }
</script>
</head>

<body id="page-top">
	<div id="wrapper"><!-- Page Wrapper -->
		<jsp:include page="common/sidebar.jsp"></jsp:include><!-- Sidebar -->
		<div id="content-wrapper" class="d-flex flex-column">
			<div id="content"><!-- Main Content -->
				<jsp:include page="common/header.jsp"></jsp:include><!-- Topbar -->
				
				<c:if test="${not empty ntcmsg}">
					<div class="alert alert-info">${ntcmsg}</div>
				</c:if>
				<c:if test="${not empty pwmsg}">
					<div class="alert alert-info">${pwmsg}</div>
				</c:if>
				<c:if test="${not empty xssmsg}">
					<div class="alert alert-info">${xssmsg}</div>
				</c:if>
				
				<div class="container vh-100 d-flex justify-content-center align-items-start row">
					<div class="col-lg-5 d-none d-lg-block bg-register-image"></div>
					<div class="col-lg-7 border border-primary bg-white">
						<div class="p-5">
							<div class="text-center">
								<h1 class="h4 text-gray-900 mb-4">Write Board</h1>
							</div>

							<form id="writeAction" action="${pageContext.request.contextPath}/board/write" 
								method="post" enctype="multipart/form-data">
								<table style="display: none;">
									<tr>
										<td>번호</td>
									</tr>
								</table>

								<div class="form-group">
									<label for="board_title">제목</label>
									<input type="text" class="form-control form-control-user"
										name="board_title" placeholder="Title" required>
								</div>
								<div class="form-group">
									<label for="board_writer">작성자</label>
									<input type="text" class="form-control form-control-user"
										name="board_writer" value="${memberName}" readonly>
								</div>
								<div class="form-group">
									<label for="board_content">내용</label>
									<div id="contents"></div>
									<textarea name="board_content" id="board_content"
										style="display: none;"></textarea>
									<input type="hidden" name="image_name" id="image_name">
									<input type="hidden" name="image_path" id="image_path">
								</div>
								<div class="custom-file">
									<input type="file" class="custom-file-input"
										name="file" id="file_name">
									<label for="file_name" class="custom-file-label">첨부파일</label>
								</div>
								<div class="form-group">
									<label for="open_yn">공개 여부</label><br>
									<label>
										<input type="radio" name="open_yn" value="1"
											${open_yn=='1'?'checked':''} required>공개 &nbsp;
									</label>
									<label>
										<input type="radio" name="open_yn" value="0"
											${open_yn=='0'?'checked':''}>비공개
									</label>
								</div>
								<div class="form-group" id="password" style="display: none;">
									<label>비밀번호 입력 (숫자 4자리)</label>
									<input type="password" class="form-control" 
										name="board_pw" maxlength="4" pattern="\d{4}" placeholder="Ex)1234"/>
								</div>
								<div class="form-check">
									<input type="checkbox" class="form-check-input"
										name="noticeCheck" id="notice_no" value="1">
									<label class="form-check-label" for="notice_no">공지로 등록</label>
								</div>
								<c:if test="${not empty message}">
  									<input type="hidden" id="messageType" value="${messageType}">
 									<input type="hidden" id="message" value="${message}">
								</c:if>
								<br>
								<button type="submit" class="btn btn-primary btn-user btn-block">
									Upload Board
								</button>
							</form>
						</div>
					</div>
				</div>
			</div><!-- End of Main Content -->
		</div><!-- End of Content Wrapper -->
	</div><!-- End of page Wrapper -->
	<jsp:include page="common/footer.jsp"></jsp:include><!-- Scroll to Tpop Button -->

	<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
	
	<script>
	const editor = new toastui.Editor({
		  el: document.querySelector("#contents"),
		  height: "500px",
		  initialEditType: "WYSIWYG",
		  initialValue: '',
		  previewStyle: "vertical",
		  placeholder: "내용을 입력하세요",
		  theme: "dark",
		  events: {
		    change: function () {
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

    
	    document.getElementById("writeAction").addEventListener("submit", function(e){
    		const title = document.querySelector('input[name="board_title"]').value;
    		const content = editor.getMarkdown();
    		const xssPattern = /<script.*?>.*?<\/script>|javascript:/gi;
    	
    		if(xssPattern.test(title)||xssPattern.test(content)){
    			alert("XSS 공격이 감지되었습니다. 다시 작성해주세요.");
    			e.preventDefault();
    			return false;
    		}
    	
    		document.getElementById("board_content").value=content;
    		document.querySelector("#contents").classList.add("toastui-editor-dark");
    	});
	</script>

	<script>
		$('input[name="open_yn"]').on('change', function(){
			if($(this).val()==='0'){
				$('#password').show();
			} else{
				$('#password').hide();
			}
		});
	</script>

	<script>
		$(document).ready(function(){
			$("#file_name").on('change', function(){
				var fileName= $(this).val().split('\\').pop();
				$(this).next('.custom-file-label').html(fileName);
			});
		});
	</script>

	<script>
		$(document).ready(function(){
			const xssmsg = "${xssmsg}";
			if (xssmsg) {
				alert(xssmsg);
			}
		});
	</script>
</body>
</html>