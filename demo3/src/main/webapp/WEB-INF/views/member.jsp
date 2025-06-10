<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

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
    	location.href="${pageContext.request.contextPath}/member/memwrite";
    }) 
    $.ajax({
    url: "${pageContext.request.contextPath}/member/list",
    cache: false,
    success: function(result) {             
        var html = "";
        result.forEach(function(item) {
            html += "<tr> <td><a href='${pageContext.request.contextPath}/member/memview?member_no=" + item.member_no + "'>" + item.member_id + "</a></td></tr>";
        });
        $("#listArea").html(html); // append → html()로 변경하여 목록 초기화 후 다시 추가
        $('#example').DataTable();
    }
});
     
} );

function goViewpage(member_no){
	location.href="memview?member_no="+member_no;
}

function(){
	
}

</script>

<script>
    $(document).ready(function() {
        $.ajax({
            type: "GET",
            url: "/member/list",  // 게시판 목록을 가져오는 URL
            success: function(data) {
                var memberListHtml = "";
                data.forEach(function(member) {
                    memberListHtml += "<tr>";
                    memberListHtml += "<td>" + member.member_no + "</td>";
                    memberListHtml += "<td><a href='/member/memview?member_no=" + member.member_no + "'>" + member.member_id + "</a></td>";
                    memberListHtml += "<td>" + member.member_pwd + "</td>";
                    memberListHtml += "<td>" + member.member_name + "</td>";
                    memberListHtml += "<td>" + member.member_email + "</td>";
                    memberListHtml += "<td>" + member.member_phone + "</td>";
                    memberListHtml += "<td>" + member.member_type + "</td>";
                    memberListHtml += "<td><a href='/member/memupdate?member_no=" + member.member_no + "'>수정</a> <a href='/member/memdelete?member_no=" + member.member_no + "'>삭제</a></td>";
                    memberListHtml += "</tr>";
                });
                $("#memberList").html(memberListHtml);  // 동적으로 목록을 채움
            }
        });
    });
</script>


</head>
<body>

	<div class="jumbotron text-center" style="margin-bottom: 0">
		<h1>회원목록</h1>
	</div>
	<nav class="navbar navbar-expand-sm bg-dark navbar-dark">
		<div class="collapse navbar-collapse" id="collapsibleNavbar">
			<ul class="navbar-nav">
				<li class="nav-item"><a class="nav-link"
					href="${pageContext.request.contextPath}">돌ㅇㅏ가기</a></li>

			</ul>
		</div>
	</nav>

	<c:if test="${not empty message}">
		<div class="alert alert-success">${messages}</div>
	</c:if>




	<h3>목록</h3>

	<table id="memberList" border="1">
		<tr>
			<td>번호</td>
			<td>아이디</td>
			<td>비밀번호</td>
			<td>이름</td>
			<td>이메일</td>
			<td>전화번호</td>
			<td>성별</td>
			<td>우편번호</td>
			<td>도로명주소</td>
			<td>지번주소</td>
			<td>상세주소</td>

		</tr>
		<c:forEach var="member" items="${memberList}">
			<tr>
				<td>${member.member_no}</td>
				<td>${member.member_id}</td>
				<td>${member.member_pwd}</td>
				<td>${member.member_name}</td>
				<td>${member.member_email}</td>
				<td>${member.member_phone}</td>
				<td>${member.member_type}</td>
				<td>${member.postal_addr}</td>
				<td>${member.road_addr}</td>
				<td>${member.street_addr}</td>
				<td>${member.detail_addr}</td>
				<td><a
					href="${pageContext.request.contextPath}/member/memview?member_no=${member.member_no}">
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
</body>
</html>
