package com.gdu.semi.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.gdu.semi.domain.AttachDTO;
import com.gdu.semi.domain.UploadBoardDTO;
import com.gdu.semi.mapper.UploadBoardMapper;
import com.gdu.semi.util.MyFileUtil;
import com.gdu.semi.util.PageUtil;


@Service
public class UploadBoardServiceImpl implements UploadBoardService {

	
	@Autowired
	private UploadBoardMapper uploadBoardMapper;
	
	@Autowired
	private MyFileUtil myFileUtil;
	
	@Autowired
	private PageUtil pageUtil;
	
	@Override
	public ResponseEntity<Object> getUpLoadList(int pageNo) {
		
		int page = pageNo ;
		int totalRecord = uploadBoardMapper.selectUploadListCount();
		pageUtil.setPageUtil(page, totalRecord);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("begin", pageUtil.getBegin());
		map.put("end", pageUtil.getEnd());
		
		  
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("uploadList", uploadBoardMapper.selectUploadListByMap(map));
		result.put("beginNo", totalRecord - (page - 1) * pageUtil.getRecordPerPage());
		result.put("beginPage", pageUtil.getBeginPage());
		result.put("endPage", pageUtil.getEndPage());
		result.put("totalPage", pageUtil.getTotalPage());
		result.put("page", pageUtil.getPage());		
		
		return new ResponseEntity<Object>(result , HttpStatus.OK) ;
	}
	
	@Override
	public ResponseEntity<Object> getFindUploadList(HttpServletRequest request) {
		Optional<String> opt = Optional.ofNullable(request.getParameter("pageNo"));
		int pageNo = Integer.parseInt(opt.orElse("1"));
		
		String column = request.getParameter("column");
		String query = request.getParameter("query");
		System.out.println(pageNo);
		System.out.println(column);
		System.out.println(query);
		
		
		Map<String, Object> count = new HashMap<>();
		count.put("column", column);
		count.put("query", query);	
		int totalRecord = uploadBoardMapper.selectFindUploadCount(count);
		
		Map<String, Object> findList = new HashMap<>();
		findList.put("column", column);
		findList.put("query", query);
		findList.put("begin", pageUtil.getBegin());
		findList.put("end", pageUtil.getEnd());
		
		System.out.println("검색조건 : " +findList);
		System.out.println("총레코드 개수  " + totalRecord);
		System.out.println("페이지넘버  " + pageNo);
		
		pageUtil.setPageUtil(pageNo, totalRecord);
		
		System.out.println("토탈페이지" +pageUtil.getTotalPage());
		System.out.println("파인드리스트" + uploadBoardMapper.selectFindUploadList(findList));
		System.out.println("beginPage" + pageUtil.getBeginPage());
		System.out.println("endPage" + pageUtil.getEndPage());
		
		int abc = (int)Math.ceil((double)totalRecord/5);
		System.out.println("Abc : " + abc);
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("uploadList", uploadBoardMapper.selectFindUploadList(findList));
		result.put("beginNo", totalRecord - (pageNo - 1) * pageUtil.getRecordPerPage());
		result.put("beginPage", pageUtil.getBeginPage());
		result.put("endPage", pageUtil.getEndPage());
		result.put("totalPage", pageUtil.getTotalPage());
		result.put("page", pageUtil.getPage());
		result.put("column", column);
		result.put("query", query);
		
		
		return new ResponseEntity<Object>(result,HttpStatus.OK);
	}
	
	
	@Transactional
	@Override
	public ResponseEntity<Object> save(MultipartHttpServletRequest multipartreRequest, HttpServletResponse response) {
		
		String title = multipartreRequest.getParameter("title");
		String content = multipartreRequest.getParameter("content");
		String ip = multipartreRequest.getRemoteAddr();
		String id = multipartreRequest.getParameter("id");
		
	
		
		UploadBoardDTO upload = UploadBoardDTO.builder()
				.uploadTitle(title)
				.uploadContent(content)
				.ip(ip)
				.id(id)
				.build();
		
	
		
		int uploadResult = uploadBoardMapper.insertUpload(upload);
		
		List<MultipartFile> files = multipartreRequest.getFiles("files");
	
		
		int attachResult = 0;
		
		if(files.get(0).getSize() == 0) {
			attachResult = 1;
		} else {
			attachResult = 0;
		}
		
		AttachDTO attach = null;
		
		for(MultipartFile multipartFile : files) {
			try {
				if(multipartFile != null && multipartFile.isEmpty() == false ) {
					
					String origin = multipartFile.getOriginalFilename();
					origin = origin.substring(origin.lastIndexOf("\\") + 1); 
					
					String filesystem = myFileUtil.getFilename(origin);
					
					String path = myFileUtil.getTodayPath();
					
					File dir =new File(path);
					if(dir.exists() == false ) {
						dir.mkdirs();
					}
					
					File file = new File(dir, filesystem);
					
					multipartFile.transferTo(file);
					
					attach = AttachDTO.builder()
							.path(path)
							.origin(origin)
							.filesystem(filesystem)
							.uploadBoardNo(upload.getUploadBoardNo())
							.build();
					
					attachResult += uploadBoardMapper.insertAttach(attach);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if(uploadResult > 0 && attachResult > 0 && (attach != null)) {
			System.out.println(uploadResult);
			System.out.println(attachResult);
			int result = uploadBoardMapper.updateIncreasePoint(id);
			System.out.println("포인트 적립 성공" + result);
		} else {
			
		}
		
		
		ResponseEntity<Object> entity = null;
		if(uploadResult > 0 && attachResult == files.size()) {
			entity = new ResponseEntity<Object>(HttpStatus.OK); 
		} else {
			entity = new ResponseEntity<Object>(HttpStatus.INTERNAL_SERVER_ERROR);  
		}
		
		return entity;
	}
	
	
	@Override
	public int increaseHit(int uploadBoardNo) {
		return uploadBoardMapper.updateHit(uploadBoardNo);
	}
	
	@Override
	public ResponseEntity<Object> getUploadByNo(int uploadBoardNo) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("upload", uploadBoardMapper.selectUploadByNo(uploadBoardNo));
		map.put("attachList", uploadBoardMapper.selectAttachList(uploadBoardNo));
				
		return new ResponseEntity<Object> (map , HttpStatus.OK);
	}
	
	@Override
	public ResponseEntity<Resource> download(String userAgent, int attachNo) {
		AttachDTO attach = uploadBoardMapper.selectAttachByNo(attachNo);
		File file = new File(attach.getPath(), attach.getFilesystem());
		
		Resource resource = new FileSystemResource(file);
		
		if(resource.exists() == false) {
			return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
		}
		
		uploadBoardMapper.updateDownloadCnt(attachNo);
		
		String origin = attach.getOrigin();
		try {
			
			if(userAgent.contains("Trident")) {
				origin = URLEncoder.encode(origin, "UTF-8" ).replaceAll("\\+", " ");
			}
			else if(userAgent.contains("Edg")) {
				origin = URLEncoder.encode(origin, "UTF-8");
			} else {
				origin = new String(origin.getBytes("UTF-8"), "ISO-8859-1");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
//		uploadBoardMapper.updateDownloadPoint(id);
		
		HttpHeaders header = new HttpHeaders();
		header.add("Content-Disposition", "attachment; filename=" + origin);
		header.add("Content-Length", file.length() + "");
		
		
		return new ResponseEntity<Resource>(resource, header, HttpStatus.OK);
		
				
	}
	
	@Override
	public ResponseEntity<Resource> downloadAll(String userAgent, int uploadBoardNo) {
		List<AttachDTO> attachList = uploadBoardMapper.selectAttachList(uploadBoardNo);
		
		FileOutputStream fout = null;
		ZipOutputStream zout = null;
		FileInputStream fin = null;
		
		String tmpPath = "storage" + File.separator + "temp";
		
		File tmpDir = new File(tmpPath);
		if(tmpDir.exists() == false) {
			tmpDir.mkdirs();
		}
		
		String tmpName = System.currentTimeMillis() + ".zip";
		
		try {
			
			fout = new FileOutputStream(new File(tmpPath, tmpName));
			zout = new ZipOutputStream(fout);
			
			if(attachList != null && attachList.isEmpty() == false) {
				for(AttachDTO attach : attachList) {
					
					ZipEntry zipEntry = new ZipEntry(attach.getOrigin());
					zout.putNextEntry(zipEntry);
					
					fin = new FileInputStream(new File(attach.getPath(),attach.getFilesystem()));
					byte[] buffer = new byte[1024];
					int length;
					while((length = fin.read(buffer))!= -1) {
						zout.write(buffer, 0 , length);
					}
					zout.closeEntry();
					fin.close();
					
					uploadBoardMapper.updateDownloadCnt(attach.getAttachNo());
	
				}
				
				zout.close();
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		File file = new File(tmpPath, tmpName);
		Resource resource = new FileSystemResource(file);
		
		
		if(resource.exists() == false ) {
			return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
		}
		
		
		HttpHeaders header = new HttpHeaders();
		header.add("Content-Disposition", "atachment; filename=" + tmpName);
		header.add("Content-Length", file.length() + "");
		
		return new ResponseEntity<Resource>(resource, header, HttpStatus.OK);
	}
	
	@Override
	public ResponseEntity<Object> usePoint(HttpServletRequest request) {
		String id = request.getParameter("id");
		System.out.println(id);
		int point = uploadBoardMapper.selectPoint(id);
		System.out.println(point);
		ResponseEntity<Object> entity = null;
		
		if(point >= 2) {
			int pointResult = uploadBoardMapper.updateDownloadPoint(id);
			
			if(pointResult > 0) {
				entity =  new ResponseEntity<Object>(HttpStatus.OK);
			} else {
				entity = new ResponseEntity<Object>(HttpStatus.INTERNAL_SERVER_ERROR);
			}
			
		} else {
			entity = new ResponseEntity<Object>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		

		return entity;
		
	}
	
	@Transactional
	@Override
	public ResponseEntity<Object> modifyUpload(MultipartHttpServletRequest mulRequest, HttpServletResponse response) {
		
		int uploadBoardNo = Integer.parseInt(mulRequest.getParameter("uploadBoardNo"));
		String title = mulRequest.getParameter("title");
		String content = mulRequest.getParameter("content");
		
		UploadBoardDTO upload = UploadBoardDTO.builder()
							.uploadBoardNo(uploadBoardNo)
							.uploadTitle(title)
							.uploadContent(content)
							.build();
		int uploadResult = uploadBoardMapper.updateUpload(upload);
		
		List<MultipartFile> files = mulRequest.getFiles("files");
		
		int attachResult;
		if(files.get(0).getSize() == 0) {
			attachResult = 1;
		} else {
			attachResult = 0;
		}
		
		for(MultipartFile multipartFile : files) {
			try {
				if(multipartFile != null && multipartFile.isEmpty() == false ) {
					
					String origin = multipartFile.getOriginalFilename();
					origin = origin.substring(origin.lastIndexOf("\\") + 1 );
					
					String filesystem = myFileUtil.getFilename(origin);
					
					String path = myFileUtil.getTodayPath();
					
					File dir = new File(path);
					if(dir.exists() == false ) {
						dir.mkdirs();
					}
					
					File file = new File(dir, filesystem);
					
					multipartFile.transferTo(file);
					
					AttachDTO attach = AttachDTO.builder()
							.path(path)
							.origin(origin)
							.filesystem(filesystem)
							.uploadBoardNo(uploadBoardNo)
							.build();
							
					attachResult += uploadBoardMapper.insertAttach(attach);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		
		ResponseEntity<Object> entity = null;
		if(uploadResult > 0 && attachResult == files.size()) {
			entity = new ResponseEntity<Object>(HttpStatus.OK);
		} else {
			entity = new ResponseEntity<Object>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		
		return entity;
	}
	
	
	@Override
	public ResponseEntity<Object> removeAttachByAttachNo(int attachNo) {
		
		AttachDTO attach = uploadBoardMapper.selectAttachByNo(attachNo);
		int result = uploadBoardMapper.deleteAttach(attachNo);
		
		ResponseEntity<Object> entity = null;
		if (result > 0) {
			File file = new File(attach.getPath(), attach.getFilesystem());
			if(file.exists()) {
				file.delete();
			}
			entity = new ResponseEntity<Object>(HttpStatus.OK);
		} else {
			entity = new ResponseEntity<Object>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		return entity;
	}
	
	@Override
	public ResponseEntity<Object> removeUpload(HttpServletRequest request, HttpServletResponse response) {
		
		int uploadBoardNo = Integer.parseInt(request.getParameter("uploadBoardNo"));
		List<AttachDTO> attachList = uploadBoardMapper.selectAttachList(uploadBoardNo);
		int result = uploadBoardMapper.deleteUpload(uploadBoardNo);
		ResponseEntity<Object> entity = null;
		
		if(result > 0) {
			if(attachList != null && attachList.isEmpty() == false ) {
				for(AttachDTO attach : attachList) {
					File file = new File(attach.getPath(), attach.getFilesystem());
					if(file.exists()) {
						file.delete();
					}
				}
			}
			entity = new ResponseEntity<Object>(HttpStatus.OK);
		} else {
			entity = new ResponseEntity<Object>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		return entity;
	}
	
}
