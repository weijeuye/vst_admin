
		
	<!--酒店规则设置-->
		<div id="hotelTable" class="tabContent js-tab-con" >
			<div class="check-box">
				<p class="main-title">入住时间段划分</p>
				<div class="check-in-time">
					<#if hotelTimeList?? && hotelTimeList?size gt 0>
					<#list hotelTimeList as item>
					<span class="choose-date"><em data-id="${item.hotelTimeId}">${item.days}</em><i class="choose-delete-btn"></i></span>
					</#list>
					</#if>
					<a class="btn js-add-date" data-recommendId=${recommendId}>+新增时间段</a>
				</div>
			</div>
			<div class="check-box">
				<p class="main-title">设置各时间段所适用的酒店</p>
				<div class="check-hotel-box">
                    <!--提示语-->
					<#if hotelTimeList?exists && hotelTimeList?size gt 0>
					<ul class="check-hotel-list">
					<#list hotelTimeList as item>
					<#assign timeName = item.days/>
					<#assign timeId = item.hotelTimeId/>
					<#if item_index==0>
					<li class="active" data-timeid="${item.hotelTimeId}">${item.days}</li>
					<#else>
					<li data-timeid="${item.hotelTimeId}">${item.days}</li>
					</#if>
					</#list>
					</ul>
					<#else>
						<p>请先划分入住时间段,再来设置适用酒店哦~</p>
					</#if>
					<div id="hotelValue">
					<#if hotelSortList?? && hotelSortList?size gt 0>
					<div id="${hotelTimeId}" class="js-hotel-set-box" style="display: block">
                        <div class="manage-box">
                           	 已选酒店
                            <a class="btn btn-blue set-hotel" data-timeId="${hotelTimeId}" >设置适用酒店</a>
                            <a class="btn js-delete-all" data-timeId="${hotelTimeId}" ">清除全部适用酒店</a>
                        </div>
                        <table class="display-table">
                            <thead>
                            <tr>
                                <th width="50">匹配度</th>
                                <th width="8%">酒店名称</th>
                                <th width="50">价格</th>
                                <th width="5%">星级标准</th>
                                <th width="5%">好评度</th>
                                <th width="8%">地址</th>
                                <th width="80">操作</th>
                            </tr>
                            </thead>
                            <tbody>
					<#list hotelSortList as item>
						<tr>
						 	<td  id="hotelId" style="display:none;">${item.hotelId}</td>
	                        <td  id="priority" >${item.priority}</td>
	                        <td  id="hotelName" >${item.hotelName}</td>
	                        <td  id="hotelPrice" value=${item.hotelPrice}>
	                            &yen;${item.hotelPrice}
	                        </td>
	                        <td id="starLevel" value=${item.starLevel}>
	                        <#if item.starLevel==5>豪华型酒店<#elseif item.starLevel==4>品质型酒店<#elseif item.starLevel==3>舒适型酒店 <#elseif item.starLevel==2>简约型酒店 <#else>其他 </#if>
							</td>
	                        <td  id="goodComments" value=${item.goodComments}>
	                            <#if item.goodComments?exists>${item.goodComments}%<#else>无</#if>
	                        </td>
	                        <td  id="hotelAddress"> ${item.hotelAddress}</td>
	                        <td>
	                            <a href="javascript:;" class="up-btn">升级</a>
	                            <a href="javascript:;" class="down-btn">降级</a>
	                            <a href="javascript:;" class="delete-btn">删除</a>
	                        </td>
	                    </tr>
					</#list>
					  </tbody>
                     </table>
					<div>
					<#else>
					<!--没有设置时间段 提示-->
					<div class="no-set">
						该时间段下暂时还没有适用的酒店哦，赶快设置吧~<br>
						<a data-timeId="${hotelTimeId}" class="btn btn-blue set-hotel">立即设置</a>
					</div>
					</#if>
					<div class="save-hotel-btn">
					<a class="btn btn-blue" data-timeId="${hotelTimeId}">保存</a>
					</div>
				</div>
				
				</div ><!--id="hotelValue"-->
			</div>
		</div>
		<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
		<script src="http://pic.lvmama.com/min/index.php?f=/js/backstage/v1/common.js,/js/lv/dialog.js,/js/lv/calendar.js"></script>
		<script src="http://pic.lvmama.com/min/index.php?f=/js/backstage/vst/gallery/v1/gallery-backstage/display.js"></script>
		<!--新添加-->
		<script src="http://pic.lvmama.com/js/backstage/vst/gallery/v1/resources.js"></script>
		<script type="text/javascript" src="/vst_admin/js/My97DatePicker/WdatePicker.js"></script>
		<script type="text/javascript" src="/vst_admin/js/superfreetour/travelRecommendHotelRule.js"></script>
			
		<script>
		
		</script>