package com.example.demo.mapper;

import com.example.demo.model.MemVo;
import com.example.demo.model.ReVo;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface ReMapper {
	List<ReVo> selectReplys();

	void insertReply(ReVo vo);

	void updateReply(ReVo vo);

	void deleteReply(int replyNo);

	ReVo selectReView(int replyNo);

	void updateReMasking(ReVo vo);

	List<ReVo> selectContent(int boardNo);

	MemVo getMemId(String memberId);
}
