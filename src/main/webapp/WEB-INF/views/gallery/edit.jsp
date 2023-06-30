<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp">
	<jsp:param value="게시글 수정" name="title" />
</jsp:include>

<script>
	
	function getContextPath() {
		var begin = location.href.indexOf(location.origin) + location.origin.length;
		var end = location.href.indexOf("/", begin + 1);
		return location.href.substring(begin, end);
	}
	
	
	$(document).ready(function(){
		
		$('#galleryContent').summernote({
			width: 800,
			height: 400,
			lang: 'ko-KR',
			toolbar: [
			    ['style', ['bold', 'italic', 'underline', 'clear']],
			    ['font', ['strikethrough', 'superscript', 'subscript']],
			    ['fontsize', ['fontsize']],
			    ['color', ['color']],
			    ['para', ['ul', 'ol', 'paragraph']],
			    ['height', ['height']],
			    ['insert', ['link', 'picture', 'video']]
			],
			callbacks: {
				onImageUpload: function(files){
					for(let i = 0; i < files.length; i++) {
					var formData = new FormData();
					formData.append('file', files[i]);  
					$.ajax({
						type: 'post',
						url: getContextPath() + '/gallery/uploadImage',
						data: formData,
						contentType: false, 
						processData: false,  
						dataType: 'json',   
						success: function(resData){
							console.log('-----');
							console.log(resData);
							$('#galleryContent').summernote('insertImage', resData.src);
							
							$('#summernote_image_list').append($('<input type="hidden" name="summernoteImageNames" value="' + resData.filesystem + '">'))
						}
					});  
					
					}
					
				}  
			}  
		});
		
		
		$('#btn_list').click(function(){
			location.href = getContextPath() + '/gallery/list';
		});
		
		$('#frm_edit').submit(function(event){
			if($('#galleryTitle').val() == ''){
				alert('제목은 필수입니다.');
				event.preventDefault();  
				return;  
			}
		});
		
		
		  $(window).on("beforeunload", function() {
		        return "작성중인 글이 존재합니다. 페이지를 나가시겠습니까?";
		    });

		    $("#frm_edit").on("submit", function() {
		        $(window).off("beforeunload");
		    });
		
	});
	
</script>


	<div>
		
		<h1>작성 화면</h1>
	    
		<form id="frm_edit" action="${contextPath}/gallery/modify" method="post">
		
			<input type="hidden" name="id" value="${loginUser.id}">
			<input type="hidden" name="galleryBoardNo" value="${galleryBoard.galleryBoardNo}">
		
			<div>
				<label for="galleryTitle">제목</label>
				<input type="text" name="galleryTitle" id="galleryTitle" value="${galleryBoard.galleryTitle}">
			</div>
		
			<div>
				<label for="galleryContent">내용</label>
				<textarea name="galleryContent" name="filesystemList" id="galleryContent" >${galleryBoard.galleryContent}</textarea>
			</div>
		
			<div id="summernote_image_list"></div>
		
			<div>
				<button>수정완료</button>
				<input type="reset" value="작성초기화">
				<input type="button" value="목록" id="btn_list">
			</div>
		
		
		</form>
	
	
	</div>

</body>
</html>
	

