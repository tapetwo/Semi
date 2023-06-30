package com.gdu.semi.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.gdu.semi.domain.GalleryBoardDTO;
import com.gdu.semi.domain.SummernoteImageDTO;

@Mapper
public interface GalleryBoardMapper {
		public int selectGalleryBoardListCount();
		public List<GalleryBoardDTO> selectGalleryBoardListByMap(Map<String, Object>map);
		public int insertSummernoteImage(SummernoteImageDTO summernote);
		public int insertGalleryBoard(GalleryBoardDTO galleryBoard);
		public int updateIncreasePoint(String id);
		public int updateHit(int galleryBoardNo);
		public GalleryBoardDTO selectGalleryBoardByNo(int galleryBoardNo);
		public int updateGalleryBoard(GalleryBoardDTO galleryBoard);
		public int deleteGalleryBoard(int galleryBoardNo);
		public List<SummernoteImageDTO> selectSummernoteImageListIngalleryBoard(int galleryBoardNo);
		public List<SummernoteImageDTO> selectAllSummernoteImageList();
		
}
