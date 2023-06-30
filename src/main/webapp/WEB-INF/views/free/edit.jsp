<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp">
	<jsp:param value="블로그목록" name="title" />
</jsp:include>

	<div>
		<h3>수정페이지</h3>
		<form id="frm_board" action="${contextPath}/free/modify" method="post">
			<input type="hidden" name="freeBoardNo" value="${free.freeBoardNo}">
			<div>
				<label for="id"><strong>ID</strong></label>
				<input type="text" name="id" value="${loginUser.id}" required readonly>
			</div>
			<div>
				<label for="freeContent"><strong>CONTENT</strong></label>
			</div>
			<div>
				<textarea rows="8" cols="30" name="freeContent" id="freeContent" required>${free.freeContent}</textarea>
			</div>
			<div>
				<button>수정완료</button>
				<input type="reset" value="입력초기화">
				<input type="button" value="게시판으로가기" onclick="location.href='${contextPath}/free/list'">
			</div>
		</form>
	</div>

</body>
</html>