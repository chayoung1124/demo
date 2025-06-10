<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
	<nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">
		<form class="form-inline">
			<button id="sidebarToggleTop"
				class="btn btn-link d-md-none rounded-circle mr-3">
				<i class="fa fa-bars"></i>
			</button>
		</form>

		<ul class="navbar-nav ml-auto">
			<div class="topbar-divider d-none d-sm-block"></div>
		<li class="nav-item dropdown no-arrow"><c:choose>
				<c:when test="${not empty sessionScope.member_id}">
					<a class="nav-link dropdown-toggle" href="#" id="userDropdown"
						role="button" data-toggle="dropdown" aria-haspopup="true"
						aria-expanded="false"> <span
						class="mr-2 d-none d-lg-inline text-gray-600 small">${sessionScope.member_name}님</span>
						<img class="img-profile rounded-circle"
						src="${pageContext.request.contextPath}/img/undraw_profile.svg">
					</a>
				</c:when>
				<c:otherwise>
					<a class="dropdown-item"
						href="${pageContext.request.contextPath}/member/login"> <i
						class="fas fa-sign-in-alt fa-sm fa-fw mr-2 text-gray-400"></i>
						Login
					</a>
				</c:otherwise>
			</c:choose>

			<div
				class="dropdown-menu dropdown-menu-right shadow animated--grow-in"
				aria-labelledby="userDropdown">
				<a class="dropdown-item"
					href="${pageContext.request.contextPath}/member/memview?member_id=${sessionScope.member_id}">
					<i class="fas fa-user fa-sm fa-fw mr-2 text-gray-400"></i> My Page
				</a>

				<div class="dropdown-divider"></div>
				<a class="dropdown-item" href="#" data-toggle="modal"
					data-target="#logoutModal"> <i
					class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
					Logout
				</a>
			</div></li>
	</ul>
	</nav>
	
	<!-- Scroll to Top Button -->
	<a class="scroll-to-top rounded" href="#page-top"> <i
		class="fas fa-angle-up"></i>
	</a>
	
	<div class="modal fade" id="logoutModal" tabindex="-1" role="dialog"
		aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">Ready to Leave?</h5>
					<button class="close" type="button" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">×</span>
					</button>
				</div>
				<div class="modal-body">Select "Logout" below if you are ready
					to end your current session.</div>
				<div class="modal-footer">
					<button class="btn btn-secondary" type="button"
						data-dismiss="modal">Cancel</button>
					<form action="${pageContext.request.contextPath}/member/logout"
						method="post">
						<button type="submit" class="btn btn-primary">logout</button>
					</form>
				</div>
			</div>
		</div>
	</div>
</html>