package com.gdu.semi.batch;

import java.io.File;
import java.io.FilenameFilter;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
// import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.gdu.semi.domain.SummernoteImageDTO;
import com.gdu.semi.mapper.GalleryBoardMapper;

@EnableScheduling
@Component
public class DeleteWrongSummernoteImages {

	
	@Autowired
	private GalleryBoardMapper galleryBoardMapper;
	
	@Scheduled(cron="0 0/1 * * * *")
	public void execute() {

		String path = "C:" + File.separator + "summernoteImage";
		
		List<SummernoteImageDTO> summernoteImageList = galleryBoardMapper.selectAllSummernoteImageList();
		
		List<Path> pathList = new ArrayList<Path>();
		if(summernoteImageList != null && summernoteImageList.isEmpty() == false) {
			for(SummernoteImageDTO summernoteImage : summernoteImageList) {
				pathList.add(Paths.get(path, summernoteImage.getFilesystem()));
			}
		}
		
		File dir = new File(path);
		File[] wrongSummernoteImages = dir.listFiles(new FilenameFilter() {
			@Override
			public boolean accept(File dir, String name) {
				return !pathList.contains(new File(dir, name).toPath());
			}
		});
		
		// 삭제
		if(wrongSummernoteImages != null) {
			for(File wrongSummernoteImage : wrongSummernoteImages) {
				wrongSummernoteImage.delete();
			}
		}
		
	}
	
}
