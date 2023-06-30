<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp">
      <jsp:param value="${galleryBoard.galleryBoardNo}번 게시글" name="title"/>
</jsp:include>

   <style>
      .blind {
         display:none;
      }
   </style>
   
   <div>
   
      <h1>${galleryBoard.galleryTitle}</h1>
      
      <div>
         <span>▷ 작성일 <fmt:formatDate value="${galleryBoard.createDate}" pattern="yyyy. M. d HH:mm" /> </span>
         &nbsp;&nbsp;&nbsp;
         <span>▷ 수정일 <fmt:formatDate value="${galleryBoard.modifyDate}" pattern="yyyy. M. d HH:mm" /></span>
      </div>
      
      
      <div>
         <span>조회수 <fmt:formatNumber value="${galleryBoard.hit}" pattern="#,##0" /></span>
      </div>
      
      <hr>
      
      <div>
         ${galleryBoard.galleryContent}
      </div>
      
      <div>
         <form id="frm_btn" method="post">
            <input type="hidden" name="galleryBoardNo" value="${galleryBoard.galleryBoardNo}">
            <c:if test="${loginUser.id == galleryBoard.id}">
	            <input type="button" value="수정" id="btn_edit_galleryBoard">
	            <input type="button" value="삭제" id="btn_remove_galleryBoard">            
            </c:if>
            <input type="button" value="목록" onclick="location.href='${contextPath}/gallery/list'">
         </form>
         <script>
            $('#btn_edit_galleryBoard').click(function(){
               $('#frm_btn').attr('action', '${contextPath}/gallery/edit');
               $('#frm_btn').submit();
            });
            
            $('#btn_remove_galleryBoard').click(function(){
               if(confirm('삭제하시겠습니까?')){
                  $('#frm_btn').attr('action','${contextPath}/gallery/remove');
                  $('#frm_btn').submit();
               }
               
            });
         </script>   
      </div>
      
      <hr>
      
      <span id="btn_comment_list">
         댓글
         <span id="comment_count"></span>개
      	 좋아요
		<span id="love_count"></span>개  	
      </span>
      
      <hr>
      
      <div id="comment_area" class="blind">
         <div id="comment_list"></div>
         <div id="paging"></div>
      </div>
      
      <hr>
      
      <div>
          <form id="frm_add_comment">
             <div class="add_comment">
                <div class="add_comment_input">
                      <input type="text" name="commContent" id="commContent" placeholder="로그인이 필요한 서비스입니다.">
                </div>
                <div class="add_comment_btn">
	                   <input type="button" value="작성완료" id="btn_add_comment">
                </div>
             </div>
             <input type="hidden" name="id" value="${loginUser.id}">
             <input type="hidden" name="galleryBoardNo" value="${galleryBoard.galleryBoardNo}">
          </form>
      </div>
      
      <input type="hidden" id="page" value="1">
      
      <script>
   
      // 함수 호출
      fn_commentCount();
      fn_switchCommentList();
      fn_addComment();
      fn_commentList();
      fn_changePage();
      fn_removeComment();
      fn_switchReplyArea();
      fn_addReply();
      
      if (${loginUser.id == null}) {
    	  $('#commContent').attr('readonly', true);
		}
      
      function fn_commentCount(){
         $.ajax({
            type: 'get',
            url: '${contextPath}/comment/getCount',
            data: 'galleryBoardNo=${galleryBoard.galleryBoardNo}',
            dataType: 'json',
            success: function(resData){  
               $('#comment_count').text(resData.commentCount);
            }
         });
      }
      
      function fn_switchCommentList(){
         $('#btn_comment_list').click(function(){
            $('#comment_area').toggleClass('blind');
         });
      }
      
      function fn_addComment(){
         $('#btn_add_comment').click(function(){
            if($('#commContent').val() == ''){
               alert('댓글 내용을 입력하세요');
               return;
            }
            $.ajax({
               type: 'post',
               url: '${contextPath}/comment/add',
               data: $('#frm_add_comment').serialize(),
               dataType: 'json',
               success: function(resData){  
                  if(resData.isAdd){
                     alert('댓글이 등록되었습니다.');
                     $('#commContent').val('');
                     fn_commentList();   
                     fn_commentCount();  
                  }
               }
            });
         });
      }
      
      function fn_commentList(){
         $.ajax({
            type: 'get',
            url: '${contextPath}/comment/list',
            data: 'galleryBoardNo=${galleryBoard.galleryBoardNo}&page=' + $('#page').val(),
            dataType: 'json',
            success: function(resData){
               
               // 화면에 댓글 목록 뿌리기
               $('#comment_list').empty();
               $.each(resData.commentList, function(i, comment){
                  var div = '';
                  if(comment.depth == 0){
                     div += '<div>';
                  } else {
                     div += '<div style="margin-left: 40px;">';
                  }
                  if(comment.state == 1) {
                     div += '<div>';
                     div += '<span class="comment_id">' + comment.id + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>';
                     div += comment.commContent;
                     if(comment.depth == 0) {
                        div += '<input type="button" value="답글" class="btn_reply_area">';
                     }
                     if('${loginUser.id}' == comment.id) {
                     	div += '<input type="button" value="삭제" class="btn_comment_remove" data-comments_no="' + comment.commentsNo + '">';
                 	 }
                     div += '</div>';
                  } else {
                     if(comment.depth == 0) {
                        div += '<div>삭제된 댓글입니다.</div>';
                     } else {
                        div += '<div>삭제된 답글입니다.</div>';
                     }
                  }
                  div += '<div>';
                  moment.locale('ko-KR');
                  div += '<span style="font-size: 12px; color: silver;">' + moment(comment.createDate).format('YYYY. MM. DD hh:mm') + '</span>';
                  div += '</div>';
                  div += '<div style="margin-left: 40px;" class="reply_area blind">';
                  div += '<form class="frm_reply">';
                  div += '<input type="hidden" name="id" value="${loginUser.id}">';
                  div += '<input type="hidden" name="galleryBoardNo" value="' + comment.galleryBoardNo + '">';
                  div += '<input type="hidden" name="groupNo" value="' + comment.groupNo + '">';
                  div += '<input type="text" name="commContent" placeholder="답글을 작성하려면 로그인을 해주세요">';
                  div += '<input type="button" value="답글작성완료" class="btn_reply_add">';
                  div += '</form>';
                  div += '</div>';
                  div += '</div>';
                  $('#comment_list').append(div);
                  $('#comment_list').append('<div style="border-bottom: 1px dotted gray;"></div>');
               });
               // 페이징
               $('#paging').empty();
               var pageUtil = resData.pageUtil;
               var paging = '';
               // 이전 블록
               if(pageUtil.beginPage != 1) {
                  paging += '<span class="enable_link" data-page="'+ (pageUtil.beginPage - 1) +'">◀</span>';
               }
               // 페이지번호
               for(let p = pageUtil.beginPage; p <= pageUtil.endPage; p++) {
                  if(p == $('#page').val()){
                     paging += '<strong>' + p + '</strong>';
                  } else {
                     paging += '<span class="enable_link" data-page="'+ p +'">' + p + '</span>';
                  }
               }
               // 다음 블록
               if(pageUtil.endPage != pageUtil.totalPage){
                  paging += '<span class="enable_link" data-page="'+ (pageUtil.endPage + 1) +'">▶</span>';
               }
               $('#paging').append(paging);
            }
         });
      }  
      
      function fn_changePage(){
         $(document).on('click', '.enable_link', function(){
            $('#page').val( $(this).data('page') );
            fn_commentList();
         });
      }
      
      function fn_removeComment(){
         $(document).on('click', '.btn_comment_remove', function(){
            if(confirm('삭제된 댓글은 복구할 수 없습니다. 댓글을 삭제할까요?')){
               $.ajax({
                  type: 'post',
                  url: '${contextPath}/comment/remove',
                  data: 'commentsNo=' + $(this).data('comments_no'),
                  dataType: 'json',
                  success: function(resData){  
                     if(resData.isRemove){
                        alert('댓글이 삭제되었습니다.');
                        fn_commentList();
                        fn_commentCount();
                     }
                  }
               });
            }
         });
      }
      
      function fn_switchReplyArea(){
         $(document).on('click', '.btn_reply_area', function(){
            $(this).parent().next().next().toggleClass('blind');
         });
      }
      
      function fn_addReply(){
         $(document).on('click', '.btn_reply_add', function(){
            if($(this).prev().val() == ''){
               alert('답글 내용을 입력하세요.');
               return;
            }
            $.ajax({
               type: 'post',
               url: '${contextPath}/comment/reply/add',
               data: $(this).closest('.frm_reply').serialize(), 
               dataType: 'json',
               success: function(resData){ 
                  if(resData.isAdd){
                     alert('답글이 등록되었습니다.');
                     fn_commentList();
                     fn_commentCount();
                  }
               }
            });
         });
      }
      
   </script>
   
</div>

</body>
</html>