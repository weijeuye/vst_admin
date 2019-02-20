package com.lvmama.vst.back.biz;
import junit.framework.Assert;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.lvmama.vst.back.biz.po.BizOrderRequired;
import com.lvmama.vst.back.client.biz.service.BizOrderRequiredClientService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "classpath*:applicationContext-vst-back-web-beans.xml" })
public class BizOrderRequiredClientServiceTest {

	@Autowired
	private BizOrderRequiredClientService bizOrderRequiredService;
	
	@Autowired
	private com.lvmama.vst.back.biz.service.BizTrainService  bizTrainService;

	//OnlyForAdmin注解是否有效
	@Test
	public void testBizOrderRequired() throws Exception {
		Long reqId = 8L;
		BizOrderRequired bizOrderRequired = bizOrderRequiredService.selectByPrimaryKey(reqId);
		Assert.assertTrue(bizOrderRequired != null);
	}
	
	//整个service是否有效
	@Test
	public void testBizTrain() throws Exception {
		Long trainId = 21L;
		com.lvmama.vst.back.biz.po.BizTrain bizTrain = bizTrainService.selectByPrimaryKey(trainId);
		Assert.assertTrue(bizTrain != null);
	}

}
