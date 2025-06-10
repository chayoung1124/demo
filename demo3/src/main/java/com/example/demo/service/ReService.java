package com.example.demo.service;

import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.dao.ReDao;
import com.example.demo.mapper.ReMapper;
import com.example.demo.model.MemVo;
import com.example.demo.model.ReVo;

@Service
@Transactional
public class ReService {
	@Autowired
	private ReDao dao;
	@Autowired
	private ReMapper m;

	public void insertReply(ReVo vo) {
		m.insertReply(vo);
	}

	public List<ReVo> selectReplys() {
		return m.selectReplys();
	}

	public void updateReply(ReVo vo) {
		m.updateReply(vo);
	}

	public void deleteReply(int replyNo) {
		m.deleteReply(replyNo);
	}

	public void savePost(ReVo vo) {
		m.insertReply(vo);
	}

	public ReVo selectReView(int replyNo) {
		return m.selectReView(replyNo);

	}

	public void updateReMasking(ReVo vo) {
		m.updateReMasking(vo);
	}

	public List<ReVo> selectContent(int boardNo) {
		return m.selectContent(boardNo);
	}

	public MemVo getMemId(String memberId) {
		return m.getMemId(memberId);
	}
}
