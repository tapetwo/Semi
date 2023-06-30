package com.gdu.semi.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.gdu.semi.domain.GalleryBoardDTO;

public interface GalleryBoardService {
		public void getGalleryBoardList(Model model);
		public Map<String, Object> saveSummernoteImage(MultipartHttpServletRequest multipartRequest);
		public void saveGalleryBoard(HttpServletRequest request, HttpServletResponse response);
		public int increseGalleryBoardHit(int galleryBoardNo);
		public GalleryBoardDTO getGalleryBoardByNo(int galleryBoardNo);
		public void modifyGalleryBoard(HttpServletRequest request, HttpServletResponse response);
		public void removeGalleryBoard(HttpServletRequest request, HttpServletResponse response);
		
}
