package com.example.demo.model;

import com.example.demo.model.MemVo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MemVo {
	private int member_no; // 회원 번호
	private String member_id; // 회원 아이디
	private String member_pwd; // 회원 비밀번호
	private String member_name; // 회원 이름
	private String member_phone; // 회원 전화번호
	private int member_type; // 회원 성별
	private int postal_addr; // 회원 주소(우편번호)
	private String road_addr; // 회원 주소(도로명)
	private String street_addr; // 회원 주소(지번)
	private String detail_addr; // 회원 주소(상세)
	private String login_type; // 회원 로그인 유형
	private String member_email; // 회원 이메일
	private int count_board; // 회원 누적 게시글 수
	private int count_reply; // 회원 누적 댓글 수
}
