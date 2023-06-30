<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp">
	<jsp:param value="블로그목록" name="title" />
</jsp:include>

<script>
	
	
	$(function(){
		fn_fileCheck();
	});
	
	function fn_fileCheck(){
		
		$('#files').change(function(){
			
			let maxSize = 1024 * 1024 * 10;  // 10MB
			
			let files = this.files;
			
			for(let i = 0; i < files.length; i++){
				
				if(files[i].size > maxSize){
					alert('10MB 이하의 파일만 첨부할 수 있습니다.');
					$(this).val('');  
					return;
				}
				
			}
			
		});
		
	}
	
	$(document).ready(function(){
		$('#btn_add').click(function(){
			var form = $('#frm_write')[0];
			console.log(form);
			 var formData = new FormData(form); 
		
			$.ajax({
				type : 'POST',
				url : '${contextPath}/upload/add',
				enctype: 'multipart/form-data',
				data : formData,
				processData : false,
				contentType : false,      
				success: function(resData){
					console.log(resData);
				 	alert('등록되었습니다.')	
				 	location.href= '${contextPath}/upload/list';
				},
				error: function(jqXHR){
					alert('등록이 실패했습니다.');
					history.back();
				}
			})
		}) 
		
		
	})
	
	
</script>

	<div>
		<h1>작성화면</h1>
		
		<form id="frm_write"  >
			<input type="hidden" name="id"  value="${loginUser.id}"  >
			<div>
				<label for="title">제목</label>
				<input type="text" id="title" name="title" required="required">
			</div>
			<div>
				<label for="content">내용</label>
				<input type="text" id="content" name="content">
			</div>
			<div>
				<label for="files">첨부</label>
				<input type="file" id="files" name="files" multiple="multiple">
			</div>
			<div>
				<input type="button" value="전송1" id="btn_add">
				<input type="button" value="목록" onclick="location.href='${contextPath}/upload/list'">
			</div>
		
		</form>
	</div>

</body>
</html>