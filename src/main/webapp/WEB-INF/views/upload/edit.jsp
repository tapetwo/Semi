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
	fn_btnEdit();
	fn_editList();
});

	function fn_fileCheck(){
		
		$('#files').change(function(){
			
			let maxSize = 1024 * 1024 * 10;  
			
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
	function fn_btnEdit(){
		$('#btn_edit').click(function(){
			const form = $('#frm_edit')[0];
			console.log(form);
			const formData = new FormData(form);
			$.ajax({
				type : 'POST',
				url :'${contextPath}/upload/uModify',
				enctype :'multipart/form-data',
				data : formData,
				processData : false,
				contentType : false,
			    success : function(resData){
					console.log(resData);
					alert('수정이 성공했습니다.');
					location.href='${contextPath}/upload/detail?uploadBoardNo=' + ${edit.upload.uploadBoardNo};
				},
				error: function(jqXHR){
					alert('수정이 실패했습니다.');
					history.back();
				} 
			})
			
		});  
		
	}
	
	function fn_editList(){
	    $.ajax({
			type : 'POST',
			url : '${contextPath}/upload/uedit?uploadBoardNo=' + ${edit.upload.uploadBoardNo} ,
			dataType : 'json',
			success : function(resData){
								
				$.each(resData.attachList, function(i, attach){
				     $('<ul>')
					 .append( $('<li>').append( $('<div>').text(attach.origin).attr('data-upload_board_no', resData.upload.uploadBoardNo ).attr('data-remove_no', attach.attachNo ).attr('class','attachRemove'  )   ) )
					 .appendTo('#attachList'); 
					
				 })
				 
			}
			
		}) 
	}
	
	$(document).on('click' , '.attachRemove' , function(e){
		if(confirm('해당 첨부파일을 삭제할까요?')){
			$.ajax({
				type : 'POST',
				url : '${contextPath}/upload/attach/remove' ,
				data : 'attachNo=' + $(this).data('remove_no'),
				success : function (resData){
					alert('삭제가 성공했습니다.');
					$('#attachList').empty();
					fn_editList();
				}, 
				error : function (jqXHR){
					alert('삭제가 실패했습니다.');
					history.back();
				}
			})
		} 
	 })  


</script>

	<div>
		<h1>수정화면</h1>
		<form id ="frm_edit" >
			<input type="hidden" name="uploadBoardNo" value = "${edit.upload.uploadBoardNo}">
			<div>
				<label for="title">제목</label>
				<input type="text" id="title" name="title" value="${edit.upload.uploadTitle}" required="required">
			</div>
			<div>
				<label for="content">내용</label>
				<input type="text" id="content" name="content" value="${edit.upload.uploadContent}">
			</div>
			<div>
				<label for="files">첨부 추가 </label>
				<input type="file" id="files" name="files"   multiple="multiple">
			</div>
			<div>
				<input type="button" value="수정완료" id="btn_edit">
				<input type="button" value="목록" onclick="location.href='${contextPath}/upload/list'">
			</div>
		</form>
		
		<div>
			<h3>첨부삭제</h3>
			<form id ='attachList' method="post"></form>
		</div>
	</div>

</body>
</html>