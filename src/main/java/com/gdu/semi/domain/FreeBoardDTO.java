package com.gdu.semi.domain;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class FreeBoardDTO {
	private int freeBoardNo;
	private String id;
	private String freeTitle;
	private String freeContent;
	private String ip;
	private Date createDate;
	//private int hit;
	private int state, depth, groupNo, groupOrder;
}





















