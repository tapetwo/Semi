<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp">
	<jsp:param value="블로그목록" name="title" />
</jsp:include>



	<div>
	
		<h1>약관 동의하기</h1>
		
		<form id="frm_agree" action="${contextPath}/user/join/write">
		
			<div>
				<input type="checkbox" id="check_all" >
				<label for="check_all" class="lbl_all">모두 동의</label>
			</div>
			
			<hr>
			
			<div>
				<input type="checkbox" id="service" class="check_one">
				<label for="service" class="lbl_one">이용약관 동의(필수)</label>
				<div>
					<textarea>그냥 동의해</textarea>
				</div>
			</div>
			<div>
				<input type="checkbox" id="privacy" class="check_one">
				<label for="privacy" class="lbl_one">개인정보수집 동의(필수)</label>
				<div>
					<textarea>이것도 해라</textarea>
				</div>
			</div>
			<div>
				<input type="checkbox" id="location" name="location" class="check_one">
				<label for="location" class="lbl_one">위치정보수집 동의(선택)</label>
				<div>
					<textarea>이건 하던가 말던가</textarea>
				</div>
			</div>
			<div>
				<input type="checkbox" id="promotion" name="promotion" class="check_one">
				<label for="promotion" class="lbl_one">마케팅 동의(선택)</label>
				<div>
					<textarea>이것도 맘대로 하셈</textarea>
				</div>
			</div>
			
			<hr>
			
			<div>
				<input type="button" value="취소" onclick="history.back();">
				<button>다음</button>
			</div>
		
		</form>
		
	</div>

</body>
</html>