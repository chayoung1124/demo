<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
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
<sidebar>
<ul
	class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion"
	id="accordionSidebar">
	<a
		class="sidebar-brand d-flex align-items-center justify-content-center"
		href="${pageContext.request.contextPath}/">
		<div class="sidebar-brand-icon rotate-n-15">
			<i class="fas fa-laugh-wink"></i>
		</div>

		<div class="sidebar-brand-text mx-3">^ㅁ^</div>
	</a>

	<hr class="sidebar-divider my-0">

	<li class="nav-item"><a class="nav-link"
		href="${pageContext.request.contextPath}/"> <i
			class="fas fa-fw fa-tachometer-alt"></i> <span>Home</span>
	</a></li>

	<hr class="sidebar-divider">

	<div class="sidebar-heading">Board</div>

	<li class="nav-item"><a class="nav-link collapsed" href="#"
		data-toggle="collapse" data-target="#collapseTwo" aria-expanded="true"
		aria-controls="collapseTwo"> <i class="fas fa-fw fa-cog"></i> <span>Board</span>
	</a>
		<div id="collapseTwo" class="collapse" aria-labelledby="headingTwo"
			data-parent="#accordionSidebar">
			<div class="bg-white py-2 collapse-inner rounded">
				<h6 class="collapse-header"></h6>
				<a class="collapse-item"
					href="${pageContext.request.contextPath}/board">Board List</a>
				<hr>
				<a class="collapse-item"
					href="${pageContext.request.contextPath}/board/write"
					onclick="checkLogin(event)">Write</a>
			</div>
		</div></li>
</ul>
</sidebar>
</html>