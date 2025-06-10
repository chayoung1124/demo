<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<title>Insert title here</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<link rel="stylesheet" type="text/css"
	href="https://cdn.datatables.net/1.10.22/css/jquery.dataTables.css">
<script type="text/javascript" charset="utf8"
	src="https://cdn.datatables.net/1.10.22/js/jquery.dataTables.js"></script>
<style>
.fakeimg {
	height: 200px;
	background: #aaa;
}
</style>
<script type="text/javascript">
$(document).ready(function() {
    $("#writeBtn").click(function(){
    	location.href="${pageContext.request.contextPath}/reply/rewrite";
    }) 
    $.ajax({
    url: "/reply/list",
    cache: false,
    success: function(result) {             
        var html = "";
        result.forEach(function(item) {
            html += "<tr> <td><a href='review?reply_no=" + item.reply_no + "'>" + item.reply_writer + "</a></td></tr>";
        });
        $("#listArea").html(html); // append → html()로 변경하여 목록 초기화 후 다시 추가
        $('#example').DataTable();
    }
});
     
} );

function goViewpage(reply_no){
	location.href="review?reply_no="+reply_no;
}

function(){
	
}

</script>

<script>
    $(document).ready(function() {
        $.ajax({
            type: "GET",
            url: "/reply/list",  // 게시판 목록을 가져오는 URL
            success: function(data) {
                var replyListHtml = "";
                data.forEach(function(reply) {
                	replyListHtml += "<tr>";
                	replyListHtml += "<td>" + reply.reply_no + "</td>";
                	replyListHtml += "<td><a href='/reply/review?reply_no=" + reply.reply_no + "'>" + reply.reply_writer + "</a></td>";
                	replyListHtml += "<td>" + reply.reply_content + "</td>";
                	replyListHtml += "<td>" + reply.reply_date + "</td>";
                	replyListHtml += "<td><a href='/reply/reupdate?reply_no=" + reply.reply_no + "'>수정</a> <a href='/reply/redelete?reply_no=" + reply.reply_no + "'>삭제</a></td>";
                	replyListHtml += "</tr>";
                });
                $("#replyList").html(replyListHtml);  // 동적으로 목록을 채움
            }
        });
    });
</script>


</head>
<body>

	<div class="jumbotron text-center" style="margin-bottom: 0">
		<h1>댓글 목록</h1>
	</div>
	<nav class="navbar navbar-expand-sm bg-dark navbar-dark">
		<div class="collapse navbar-collapse" id="collapsibleNavbar">
			<ul class="navbar-nav">
				<li class="nav-item"><a class="nav-link"
					href="${pageContext.request.contextPath}">돌ㅇㅏ가기</a></li>

			</ul>
		</div>
	</nav>

	<h3>댓글 목록</h3>

	<table id="replyList" border="1">
		<tr>
			<td>번호</td>
			<td>작성자</td>
			<td>내용</td>
			<td>날짜</td>

		</tr>
		<c:forEach var="reply" items="${replyList}">
			<tr>
				<td>${reply.reply_no}</td>
				<td>${reply.member_name}</td>
				<td>${reply.reply_content}</td>
				<td><c:choose>
						<c:when test="${reply.reply_udp_date != null}">
							<fmt:formatDate value="${reply.reply_udp_date}"
								pattern="yyyy-MM-dd" /> (수정됨)
                	</c:when>
						<c:otherwise>
							<fmt:formatDate value="${reply.reply_date}" pattern="yyyy-MM-dd" />
						</c:otherwise>
					</c:choose></td>
				<td><a
					href="${pageContext.request.contextPath}/reply/review?reply_no=${reply.reply_no}">
						상세보기</a></td>
				<%-- <td>
				<a href="${pageContext.request.contextPath}/board/comment?board_no=${board.board_no}">
					댓글달기</a></td> --%>
				<%-- <td>
   					 <a href="/board/update?board_no=${board.board_no}">수정</a>
   					 <a href="/board/delete?board_no=${board.board_no}">삭제</a>
				</td> --%>

			</tr>
		</c:forEach>
	</table>
	<%-- <input type="button" value="댓글쓰기" class="btn btn-primary" onclick="location.href='${pageContext.request.contextPath}/reply/rewrite'">
	 --%>
</body>
</html>
