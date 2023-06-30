package com.gdu.semi.service;

import java.io.File;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.gdu.semi.domain.GalleryBoardDTO;
import com.gdu.semi.domain.SummernoteImageDTO;
import com.gdu.semi.mapper.GalleryBoardMapper;
import com.gdu.semi.util.MyFileUtil;
import com.gdu.semi.util.PageUtil;


@Service
public class GalleryBoardServiceImpl implements GalleryBoardService {
	
	
	private GalleryBoardMapper galleryBoardMapper;
	private PageUtil pageUtil;
	private MyFileUtil myFileUtil;
	
	@Autowired
	public void set(GalleryBoardMapper galleryBoardMapper, PageUtil pageUtil, MyFileUtil myFileUtil) {
		this.galleryBoardMapper=galleryBoardMapper;
		this.pageUtil=pageUtil;
		this.myFileUtil = myFileUtil;
		
	}
	
	@Override
	public void getGalleryBoardList(Model model) {
	
		Map<String, Object> modelMap = model.asMap(); 
		HttpServletRequest request = (HttpServletRequest) modelMap.get("request");
		
		// page 파라미터
		Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
		int page = Integer.parseInt(opt.orElse("1"));
		
		// 전체 게시글 개수
		int totalRecord = galleryBoardMapper.selectGalleryBoardListCount();
		
		// 페이징 처리에 필요한 변수 계산
		pageUtil.setPageUtil(page, totalRecord);
		
		// 조회 조건으로 사용할 Map 만들기
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("begin", pageUtil.getBegin());
		map.put("end", pageUtil.getEnd());
		
		// 뷰로 전달할 데이터를 model에 저장하기 
		model.addAttribute("totalRecord", totalRecord);
		model.addAttribute("galleryBoardList", galleryBoardMapper.selectGalleryBoardListByMap(map));
		model.addAttribute("beginNo", totalRecord - (page - 1) * pageUtil.getRecordPerPage());
		model.addAttribute("paging", pageUtil.getPaging(request.getContextPath() + "/gallery/list"));
}
	
	@Override
	public Map<String, Object> saveSummernoteImage(MultipartHttpServletRequest multipartRequest) {
		
		// 파라미터 files
		MultipartFile multipartFile = multipartRequest.getFile("file");
		
		// 저장 경로
		String path = "C:" + File.separator + "summernoteImage";
				
		// 저장할 파일명
		String filesystem = myFileUtil.getFilename(multipartFile.getOriginalFilename());
		
		// 저장 경로가 없으면 만들기
		File dir = new File(path);
		if(dir.exists() == false) {
			dir.mkdirs();
		}
		
		// 저장할 File 객체
		File file = new File(path, filesystem);  
		
		// HDD에 File 객체 저장하기
		try {
			multipartFile.transferTo(file);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		// 저장된 파일을 확인할 수 있는 매핑을 반환
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("src", multipartRequest.getContextPath() + "/load/image/" + filesystem);  
		map.put("filesystem", filesystem);  
		return map;
	}
	
	@Override
	public void saveGalleryBoard(HttpServletRequest request, HttpServletResponse response) {
		
		// 파라미터 title, content
		String gallerytitle = request.getParameter("galleryTitle");
		String gallerycontent = request.getParameter("galleryContent");
		String id = request.getParameter("id");
		
		Optional<String> opt = Optional.ofNullable(request.getHeader("X-Forwarded-For"));
		String ip = opt.orElse(request.getRemoteAddr());
		
		// DB로 보낼 GalleryBoardDTO
		GalleryBoardDTO galleryBoard = GalleryBoardDTO.builder()
						.galleryTitle(gallerytitle)
						.galleryContent(gallerycontent)
						.id(id)
						.ip(ip)
						.build();
	
		// DB에 galleryBoard 저장
		int result = galleryBoardMapper.insertGalleryBoard(galleryBoard);	
		
		// 응답
		try {
			 response.setContentType("text/html; charset=UTF-8");
			 PrintWriter out= response.getWriter();
			 
			 out.println("<script>");
			 if(result > 0) {
				 
				// 파라미터 summernoteImageNames
				String[] summernoteImageNames = request.getParameterValues("summernoteImageNames");
				
				// DB에 SummernoteImage 저장
				if(summernoteImageNames !=  null) {
					for(String filesystem : summernoteImageNames) {
						SummernoteImageDTO summernoteImage = SummernoteImageDTO.builder()
											.galleryBoardNo(galleryBoard.getGalleryBoardNo())
											.filesystem(filesystem)
											.build();
						galleryBoardMapper.insertSummernoteImage(summernoteImage);
						
			 }
					galleryBoardMapper.updateIncreasePoint(id);
		}
			out.println("location.href='" + request.getContextPath() + "/gallery/list';");
	 } else {
			out.println("alert('게시글 작성이 실패했습니다.');");
			out.println("history.back();");
		}
		out.println("</script>");
		out.close();
		
	} catch (Exception e) {
		e.printStackTrace();
	}
	
  }	
	
	
	@Override
	public int increseGalleryBoardHit(int galleryBoardNo) {
		return galleryBoardMapper.updateHit(galleryBoardNo);
	
	}
	
	@Override
	public GalleryBoardDTO getGalleryBoardByNo(int galleryBoardNo) {
		
		GalleryBoardDTO galleryBoard= galleryBoardMapper.selectGalleryBoardByNo(galleryBoardNo);

		List<SummernoteImageDTO> summernoteImageList =galleryBoardMapper.selectSummernoteImageListIngalleryBoard(galleryBoardNo);
		
		if(summernoteImageList != null && summernoteImageList.isEmpty() == false) {
			for(SummernoteImageDTO summernoteImage : summernoteImageList) {
					if(galleryBoard.getGalleryContent().contains(summernoteImage.getFilesystem()) == false) {
						File file = new File("C:" + File.separator + "summernoteImage", summernoteImage.getFilesystem());
						if(file.exists()) {
							file.delete();
						}
					}
				}
			}
		return galleryBoard;
	}
	
	
	
	@Transactional
	@Override
	public void modifyGalleryBoard(HttpServletRequest request, HttpServletResponse response) {
		
			// 파라미터 title, content, galleryBoardNo
			String gallerytitle = request.getParameter("galleryTitle");
			String gallerycontent = request.getParameter("galleryContent");
			int galleryBoardNo=Integer.parseInt(request.getParameter("galleryBoardNo"));
			
			// DB로 보낼 GalleryBoardDTO
			GalleryBoardDTO galleryBoard = GalleryBoardDTO.builder()
					.galleryTitle(gallerytitle)
					.galleryContent(gallerycontent)
					.galleryBoardNo(galleryBoardNo)
					.build();
			
			// DB 수정
			int result=galleryBoardMapper.updateGalleryBoard(galleryBoard);
			
			// 응답
			try {
				
				response.setContentType("text/html; charset=UTF-8");
				PrintWriter out =response.getWriter();
				
				out.println("<script>");
				if(result > 0) {
					// 파라미터 summernoteImageNames
					String[] summernoteImageNames = request.getParameterValues("summernoteImageNames");
					
					// DB에 SummernoteImage 저장
					if(summernoteImageNames != null) {
						for(String filesystem : summernoteImageNames) {
							SummernoteImageDTO summernoteImage = SummernoteImageDTO.builder()
															.galleryBoardNo(galleryBoard.getGalleryBoardNo())
															.filesystem(filesystem)
															.build();
											galleryBoardMapper.insertSummernoteImage(summernoteImage);				
				}
			}
					
			out.println("location.href='" + request.getContextPath() + "/gallery/detail?galleryBoardNo=" + galleryBoardNo + "';");
	} else {
		out.println("alert('게시글 수정이 실패했습니다.');");
		out.println("history.back();");
	}
	out.println("</script>");
	out.close();
	
} catch (Exception e) {
	e.printStackTrace();
}
			
	}	
 @Override
 public void removeGalleryBoard(HttpServletRequest request, HttpServletResponse response) {
	 
	 // 파라미터 galleryBoardNo
	 int galleryBoardNo = Integer.parseInt(request.getParameter("galleryBoardNo"));
	 
	 // HDD에서 삭제해야 하는 SummernoteImage 리스트
	 List<SummernoteImageDTO> summernoteImageList = galleryBoardMapper.selectSummernoteImageListIngalleryBoard(galleryBoardNo);
	 
	 // DB 삭제
	 int result = galleryBoardMapper.deleteGalleryBoard(galleryBoardNo); // 외래키  제약조건에 의해서 SummernoteImage도 모두 지워짐
	 
	 // 응답
	 try {
		 	response.setContentType("text/html; charset=UTF-8");
		 	PrintWriter out=response.getWriter();
		 	
		 	out.println("<script>");
		 	if(result > 0) {
		 		
		 		// HDD 에서 SummernoteImage 리스트 삭제
		 		if(summernoteImageList != null && summernoteImageList.isEmpty()==false) {
		 			for(SummernoteImageDTO  summernoteImage : summernoteImageList) {
		 				File file = new File("C:" + File.separator + "summernoteImage", summernoteImage.getFilesystem());
		 				if(file.exists()) {
							file.delete();
		 					
		 				}
		 			}
		 		}
		 		out.println("alert('삭제 성공');");
				out.println("location.href='" + request.getContextPath() + "/gallery/list';");
		 	}else {
		 		out.println("alert('삭제 실패');");
		 		out.println("history.back();");
		 		
		 	}
		 	out.println("</script>");
			out.close();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	 
 	}
 
}