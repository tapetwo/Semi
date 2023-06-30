<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp">
	<jsp:param value="블로그목록" name="title" />
</jsp:include>
<style>
        @import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css');
</style>

	<div class="freebrd">
		<div class="brd_free">
			<div class="input_size">
				<h3>게시글 작성&nbsp;<i class="fa-regular fa-pen-to-square"></i></h3>
				<form id="frm_free" method="post" action="${contextPath}/free/add">
					<div>
						<label for="id"><strong>ID</strong></label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="text" name="id" value="${loginUser.id}" class="inputBox" size=24  required readonly>
					</div>
					<br>
					<div>
						<label for="freetitle"><strong>TITLE</strong></label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="text" name="freeTitle" placeholder="제목은 필수입니다." class="inputBox" size=17 required>
					</div>
					<br>
					<div class="inputFlex">
						<div>
							<label for="freecontent"><strong>CONTENT</strong></label>&nbsp;&nbsp;&nbsp;&nbsp;
						</div>
						<div>
							<textarea rows="8" cols="30" name="freeContent" placeholder="내용을 입력하세요." class="textBox" required>${free.freeContent}</textarea>
						</div>
					</div>
					<br>
					<div>
						<button class="btn_primary">작성완료</button>
						<input type="reset" value="입력초기화" class="btn_primary">
						<input type="button" value="게시판으로가기" onclick="location.href='${contextPath}/free/list'" class="btn_primary">
					</div>
				</form>
			</div>
		</div>
	</div>
</body>
</html>