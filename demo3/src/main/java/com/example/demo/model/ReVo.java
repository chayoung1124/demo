package com.example.demo.model;

import java.util.Date;

import com.example.demo.model.ReVo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ReVo {
	private int reply_no; // 댓글 번호
	private String reply_writer; // 댓글 작성자
	private String reply_content; // 댓글 내용
	private Date reply_date; // 댓글 작성일
	private Date reply_udp_date; // 댓글 수정일
	private int board_no; // 게시글 번호
	private String member_name; // 회원 이름
}
