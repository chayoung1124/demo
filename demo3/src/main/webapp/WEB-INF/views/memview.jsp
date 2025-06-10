<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<title>My Page</title>
<jsp:include page="common/head.jsp"></jsp:include>
<script type="text/javascript">

	var memberName="${memberView.member_id}";
		
	$.ajax({
		type: "GET",   
	    url: "${pageContext.request.contextPath}/member/count",
	    data: {member_id:memberName},
	    success: function(data) {
	    	$("#count").text(data.count);
	    } 
	});

</script>
</head>
<body id="page-top">

	<c:if test="${empty sessionScope.member_id}">
		<script>
        	alert("로그인 필요");
        	location.href = "${pageContext.request.contextPath}/member/login";
    	</script>
	</c:if>

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
					<h1 class="h3 mb-2 text-gray-800">My Page</h1>
					<p class="mb-4">마이페이지입니당</p>

					<!-- DataTales Example -->
					<div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">My Page</h6>
						</div>
						<div class="card-body">
							<div class="table-responsive">
								<table class="table table-bordered" id="dataTable" width="100%"
									cellspacing="0">
									<thead>
										<tr>
											<th>Id</th>
											<th>Password</th>
											<th>Name</th>
											<th>Email</th>
											<th>Phone</th>
											<th>Gender</th>
											<th>Address</th>
											<th>Count Board / Reply</th>
										</tr>
									</thead>

									<tbody>
										<tr>
											<td>${memberView.member_id}</td>
											<td>${memberView.member_pwd}</td>
											<td>${memberView.member_name}</td>
											<td>${memberView.member_email}</td>
											<td>${memberView.member_phone}</td>
											<td><c:choose>
													<c:when test="${memberView.member_type == 0}">Male</c:when>
													<c:when test="${memberView.member_type == 1}">Female</c:when>
												</c:choose></td>
											<td>(${memberView.postal_addr})<br> (도로명)
												${memberView.road_addr}<br> (지번)
												${memberView.street_addr}<br> (상세)
												${memberView.detail_addr}
											</td>
											<td><a
												href="${pageContext.request.contextPath}/member/count?member_id=${memberView.member_id}">나의
													누적 게시글 수, 댓글 수 보러가기</a></td>
										</tr>
									</tbody>
								</table>
								<!-- <input type="button" class="btn btn-primary" id="updateBtn" value="수정">
			    				<input type="button" class="btn btn-primary" id ="deleteBtn" value="삭제"> -->
								<c:if test="${sessionScope.member_id eq memberView.member_id}">
									<input type="button" class="btn btn-outline-primary"
										onclick="updatemember()" value="회원정보 수정">
									<input type="button" class="btn btn-outline-danger"
										onclick="deletemember()" value="회원 탈퇴">
								</c:if>

								<script>
			    					function updatemember() {
			                        	var sessionMemberId = "${sessionScope.member_id}";
			                        	var memberId = "${memberView.member_id}";

				                        if (sessionMemberId === memberId) {
				                            location.href = "${pageContext.request.contextPath}/member/memupdate?member_id=" + "${memberView.member_id}";
				                        } else {
				                            alert("작성자만 수정할 수 있음");
			    	                    }
			        	            }
			            	        function deletemember() {
			                	        var sessionMemberId = "${sessionScope.member_id}";
			                    	    var memberId = "${memberView.member_id}";

			                        	if (sessionMemberId === memberId) {
			                            	if (confirm("정말로 삭제하시겠습니까?")) {
			                                	location.href = "${pageContext.request.contextPath}/member/memdelete?member_no=" + "${memberView.member_no}";
			                            	}
			                        	} else {
			                            	alert("작성자만 삭제할 수 있습니다.");
			                        	}
			                    	}
			    				</script>
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