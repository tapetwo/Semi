<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp">
	<jsp:param value="블로그목록" name="title" />
</jsp:include>

	<div>
		<h1>휴면계정안내</h1>
		
		<div>
			안녕하세요!<br>
			${sleepUser.id}님은 1년 이상 로그인하지 않아 관련 법령에 의해 휴면계정으로 전환되었습니다.
			<ul>
				<li>가입일 ${sleepUser.joinDate}</li>
				<li>마지막 로그인 ${sleepUser.lastLoginDate}</li>
				<li>휴면전환일 ${sleepUser.sleepDate}</li>
			</ul>
		</div>
		<div>
			<div>
				휴면해제를 위해 휴면해제 버튼을 클릭해 주세요.
			</div>
			<form action="${contextPath}/user/restore" method="post" id="frm_restore">
				<div>
					<button>휴면해제</button>
					<input type="button" value="취소" onclick="location.href='${contextPath}'">
				</div>
			</form>
		</div>
	</div>
	
</body>
</html>