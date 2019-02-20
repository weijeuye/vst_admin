package com.lvmama.vst.back.prod.scenicHotel;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import static org.junit.Assert.*;

import com.lvmama.vst.back.dujia.comm.prod.po.ProdProductDescription;
import com.lvmama.vst.back.dujia.comm.route.po.ProdLineRouteDescription;
import com.lvmama.vst.back.dujia.group.prod.vo.TravelAlertInnerVO;
import com.lvmama.vst.back.dujia.group.route.vo.CostIncludeInnerVO;
import com.lvmama.vst.back.prod.po.ScenicHotelCostExcludeVo;
import com.lvmama.vst.back.prod.po.ScenicHotelCostIncludeVo;
import com.lvmama.vst.back.prod.po.ScenicHotelTravelAlertVo;
import com.lvmama.vst.back.prod.po.ScenicHotel_HotelVo;
import com.lvmama.vst.back.prod.po.ScenicHotel_ScenicVo;
import com.lvmama.vst.back.utils.MiscUtils;
import com.lvmama.vst.comm.utils.Pair;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "classpath*:ScenicHotelStructuringServiceTest.xml"})
public class ScenicHotelStructuringServiceTest {

	@Autowired
	private ScenicHotelStructuringService scenicHotelStructuringService;
	
	@Autowired
	private com.lvmama.phppid.dest.service.MultiDestInfoService destInfoService;
	
	@Test
	public void loadPackagedProuctName () {
		Long productId = 1162124L;
		Map<String, List<Pair<String, ScenicHotelCostIncludeVo.Item>>>  
			result = scenicHotelStructuringService.loadPackagedProuctName(productId);
		assertTrue(result != null&& !result.isEmpty());
		System.out.println("--------- loadPackagedProuctName result:\n" + result);
	}
	
	//@Test
	public void loadPackagedProcuctForTravelAlert () {
		Long productId = 1162124L;
		ScenicHotelTravelAlertVo result = scenicHotelStructuringService.loadPackagedProcuctForTravelAlert(productId);
		assertTrue(result != null );
		System.out.println("--------- loadPackagedProcuctForTravelAlert result:\n" + result);
	}
	
	//@Test
	public void loadCost() {
		Long productId = 1162124L;
		String productType = "INNERLINE";
		Long lineRouteId = 325719L;
		Long categoryId = 18L;
		Map<String, Object>  result = scenicHotelStructuringService.loadCost(productId, productType, lineRouteId, categoryId);
		assertTrue(result != null && !result.isEmpty());
	}
	
	//@Test
	public void saveCost() {
		Long productId = 1162124L;
		String productType = "INNERLINE";
		Long lineRouteId = 325719L;
		
		ProdLineRouteDescription lineRouteDescription = new ProdLineRouteDescription();
		lineRouteDescription.setProductId(productId);
		lineRouteDescription.setCategoryId(18L);
		lineRouteDescription.setLineRouteId(lineRouteId);
		lineRouteDescription.setProductType(productType);
		
		ScenicHotelCostIncludeVo costIncludeInnerVO = new ScenicHotelCostIncludeVo();
		costIncludeInnerVO.setBuyPresent("赠送测试");
		costIncludeInnerVO.setMeal("用餐测试");
		costIncludeInnerVO.setSupplement("附加条款");
		costIncludeInnerVO.setEntertainment("娱乐");
		costIncludeInnerVO.setTransport("交通");
		//hotel
		ScenicHotelCostIncludeVo.Item hotel = new ScenicHotelCostIncludeVo.Item();
		hotel.set_default("默认值无");
		hotel.setContent("呵呵， 睡大马路");
		hotel.setProductIds("123, 321");
		costIncludeInnerVO.setHotel(hotel);
		
		//ticket
		ScenicHotelCostIncludeVo.Item ticket = new ScenicHotelCostIncludeVo.Item();
		ticket.set_default("暂无");
		ticket.setContent("张家界欢迎你");
		ticket.setProductIds("9527, 223");
		costIncludeInnerVO.setTicket(ticket);
		
		
		ScenicHotelCostExcludeVo costExcludeInnerVO = new ScenicHotelCostExcludeVo();
		costExcludeInnerVO.setPresentItem('Y');
		costExcludeInnerVO.setSelfPayItem('Y');
		costExcludeInnerVO.setSecurityItem('Y');
		costExcludeInnerVO.setSupplement("附加测试");
		
		String currentUserName = "lv2399";
		boolean isOK = scenicHotelStructuringService.saveCost(costIncludeInnerVO, costExcludeInnerVO, lineRouteDescription, currentUserName);
		assertTrue(isOK);
	}
	
	//@Test
	public void loadTravelAlert() {
		Long productId = 1162124L;
		String productType = "INNERLINE";
		Map<String, Object> result = scenicHotelStructuringService.loadTravelAlert(productId, productType);
		assertTrue(result != null && !result.isEmpty());
	}
	
	@Test
	public void saveTravelAlertTest() {
		List<ScenicHotel_ScenicVo> ticketList = new ArrayList<ScenicHotel_ScenicVo>();
		ScenicHotel_ScenicVo ticket = new ScenicHotel_ScenicVo();
		ticketList.add(ticket);
		ticket.setName("黄山风景区");
		ticket.setId(123456L);
		
		List<ScenicHotel_HotelVo> hotelList = new ArrayList<ScenicHotel_HotelVo>();
		ScenicHotel_HotelVo hotel = new ScenicHotel_HotelVo();
		hotelList.add(hotel);
		hotel.setAddress("上海市");
		hotel.setName("锦江国际大酒店");
		
		Long travleProdDescId = null;
		ScenicHotelTravelAlertVo travelAlertInnerVO = new ScenicHotelTravelAlertVo();
		travelAlertInnerVO.setHotelExtra("酒店附加信息");
		travelAlertInnerVO.setSupplements("额外数据， 比如历史数据");
		travelAlertInnerVO.setTicketExtra("门票额外数据");
		travelAlertInnerVO.setTicketList(ticketList);
		travelAlertInnerVO.setHotelList(hotelList);
		
		Long productId = 1162124L;
		String productType = "INNERLINE";
		
		ProdProductDescription productDescription= new ProdProductDescription();
		productDescription.setCategoryId(18L);
		productDescription.setProductId(productId);
		productDescription.setProductType(productType);
		
		boolean isOK = this.scenicHotelStructuringService.saveTravelAlert(travelAlertInnerVO, productDescription, 2.0, "admin");
		assertTrue(isOK);
	}
	
	@SuppressWarnings({ "unchecked" })
	@Test
	public void getDestInfoTest() {
		long destId = 101027;
		com.lvmama.phppid.vo.ResultHandleT<Map<String, Object>> wrap = destInfoService.getMuitiDestInfoByDestId(destId);
		Map<String, Object> destInfo = null;
		if(wrap != null ) {
			destInfo = wrap.getReturnContent();
		}
		//{addressList=[{enAddress=, address=浙江省湖州市南浔镇人瑞路51号}]
		String address = null;
		if(destInfo != null) {
			List<Map<String, Object>> addressList = (List<Map<String, Object>>)destInfo.get("addressList");
			if(addressList != null && !addressList.isEmpty()) {
				address = (String)addressList.get(0).get("address");
			}
		}
		assertTrue(destInfo!= null && address != null );
	}
}
