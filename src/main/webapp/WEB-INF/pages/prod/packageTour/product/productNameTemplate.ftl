<#if bizCategory??&&bizCategory.categoryId == '18'||prodProduct??&&prodProduct.bizCategory.categoryId == '18' >
<!--/自由行——国内增加名称START-->
	<#if subCategoryId == '181' ||  prodProduct?? && prodProduct.subCategoryId =='181'>
		<div class="dialog dialog-default lt_dialog addName_dialog addName_zyx_gn_dialog INNERLINE"style="position: absolute;">
		    <div class="dialog-inner clearfix">
		        <a data-dismiss="dialog" class="dialog-close lt-dialog-close">&times;</a>
		        <div class="dialog-header">添加国内产品名称</div>
		        <div class="dialog-body">
		            <div class="dialog-content clearfix">
		                <p class="add-name-input">
		                    <b>产品名称主标题：</b>
		                    <input type="hidden" class="add-main-title"/>
		                    <input type="hidden" class="add-sub-title"/>
		                    <input type="hidden" class="add-sub-title-4-tnt"/>
		                    <em class="lt-not-null">*</em>
		                    <input type="text" placeholder="目的地" name="destination" class="input-text lt-w200 js-add-mdd" maxlength="40"/>
		                    <em class="lt-not-null">*</em>
		                    <select class="day-count" name="dayNumber" >
		                        <option value="1">1</option>
		                        <option value="2">2</option>
		                        <option value="3">3</option>
		                        <option value="4">4</option>
		                        <option value="5">5</option>
		                        <option value="6">6</option>
		                        <option value="7">7</option>
		                        <option value="8">8</option>
		                        <option value="9">9</option>
		                        <option value="10">10</option>
		                        <option value="11">11</option>
		                        <option value="12">12</option>
		                        <option value="13">13</option>
		                        <option value="14">14</option>
		                        <option value="15">15</option>
		                        <option value="16">16</option>
		                        <option value="17">17</option>
		                        <option value="18">18</option>
		                        <option value="19">19</option>
		                        <option value="20">20</option>
		                        <option value="21">21</option>
		                        <option value="22">22</option>
		                        <option value="23">23</option>
		                        <option value="24">24</option>
		                        <option value="25">25</option>
		                        <option value="26">26</option>
		                        <option value="27">27</option>
		                        <option value="28">28</option>
		                        <option value="29">29</option>
		                        <option value="30">30</option>
		                    </select>天
		                    <select class="night-count" name="nightNumber" >
		                        <option value="0">0</option>
		                        <option value="1">1</option>
		                        <option value="2">2</option>
		                        <option value="3">3</option>
		                        <option value="4">4</option>
		                        <option value="5">5</option>
		                        <option value="6">6</option>
		                        <option value="7">7</option>
		                        <option value="8">8</option>
		                        <option value="9">9</option>
		                        <option value="10">10</option>
		                        <option value="11">11</option>
		                        <option value="12">12</option>
		                        <option value="13">13</option>
		                        <option value="14">14</option>
		                        <option value="15">15</option>
		                        <option value="16">16</option>
		                        <option value="17">17</option>
		                        <option value="18">18</option>
		                        <option value="19">19</option>
		                        <option value="20">20</option>
		                        <option value="21">21</option>
		                        <option value="22">22</option>
		                        <option value="23">23</option>
		                        <option value="24">24</option>
		                        <option value="25">25</option>
		                        <option value="26">26</option>
		                        <option value="27">27</option>
		                        <option value="28">28</option>
		                        <option value="29">29</option>
		                        <option value="30">30</option>
		                        <option value="31">31</option>
		                    </select>晚
		                    <input type="text" placeholder="附加信息" name="destination" class="input-text lt-w300 add-mdd-note"  maxlength="60"/>
		                </p>
		                <div class="add-name-input">
							<b>产品名称副标题：</b>
							<div class="add-content-box clearfix">
								<span class="tit">+添加酒店</span>
								<div class="add-title-box">
									<div class="add-row on">
										<span class="inquiry-common-icon down-icon"></span>
										<select id="multiple-hotel" class="form-control form-control-chosen js-from-hotel" data-placeholder="酒店必填" multiple>
											<option></option>
											
										</select>
										<p class="tips">最多支持添加10个标签</p>
									</div>
									<div class="add-row">
										<input type="text" placeholder="附加信息" name="destination" class="input-text lt-w400 hotel-add-note"	maxlength="60"/>
										<p class="tips">最多60字符</p>
									</div>
								</div>
							</div>
							<div class="add-content-box clearfix">
								<span class="tit">+添加景区</span>
								<div class="add-title-box on">
										<div class="add-row">
											<span class="inquiry-common-icon down-icon"></span>
											<select id="multiple-spot" class="form-control form-control-chosen js-from-spot" data-placeholder="景区" multiple>
												<option></option>
											</select>
											<p class="tips">最多支持添加10个标签</p>
										</div>
										<div class="add-row">
											<input type="text" placeholder="附加信息" name="destination" class="input-text lt-w400 spot-add-note"	maxlength="60"/>
											<p class="tips">最多60字符</p>
										</div>
								</div>
							</div>
							<div class="add-content-box">
									<span class="tit">+营销信息</span>
									<input type="text" placeholder="附加信息" name="destination" class="input-text lt-w400 jd-sale-mdd"
										data-tip="此输入框为<i class='add-red'>必填</i> <br/>填写城市名称、景区名称，以顿号为间隔，*星、纯玩/精品，星级以中文字填写（可不填，达到准四无挂牌可用“精品”二字）；如“三亚天涯海角、大东海纯玩”</br><i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
										maxlength="60"/>
								</div>
						</div>
		
		                <div class="addName-help-tips clearfix">
		                 	  帮助提示:<p style="color:red">请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||"</p>
		                 	  <p style="color:red">产品主标题+副标题名称总字数不能超过200字</p>
		                </div>
		                <p class="add-name-view">
		                    <span class="js-view-btn" style="cursor: pointer;"><b>名称预览：</b></span>
		                    <span class="add-name-content"></span>
		                </p>
		            </div>
		        </div>
		        <div class="dialog-footer">
		            <button class="lt-button lt-mr15 js-dialog-confirm">确认</button>&nbsp;
		            <button class="lt-button lt-mr15 lt-mr15-grey lt-dialog-close">取消</button>
		        </div>
		    </div>
		</div>
	<#else>
	<div class="dialog dialog-default lt_dialog addName_dialog addName_zyx_gn_dialog INNERLINE">
	    <div class="dialog-inner clearfix">
	        <a data-dismiss="dialog" class="dialog-close lt-dialog-close">&times;</a>
	        <div class="dialog-header">添加国内产品名称</div>
	        <div class="dialog-body">
	            <div class="dialog-content clearfix">
	                <p class="add-name-input">
	                    <b>产品名称主标题：</b>
	                    <input type="hidden" class="add-main-title"/>
	                    <input type="hidden" class="add-sub-title"/>
	                    <input type="hidden" class="add-sub-title-4-tnt"/>
	                    
	                    <em class="lt-not-null">*</em>
	                    <input type="text" placeholder="目的地" name="destination" class="input-text lt-w100 add-mdd"
	                           data-tip="此输入框为<i class='add-red'>必填</i> <br/>填写城市名称、景区名称，以顿号为间隔，*星、纯玩/精品，星级以中文字填写（可不填，达到准四无挂牌可用“精品”二字）；如“三亚天涯海角、大东海纯玩”</br><i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
	                           maxlength="40"/>
	                    <input type="text" placeholder="交通方式" name="traffic" class="input-text lt-w100 add-traffic"
	                           data-tip="此输入框为<i class='add-red'>必填</i> <br/>填写产品的交通方式，巴士（不能写“汽车”）、轮船、快艇、慢艇、高铁、动车、火车、飞机  如：双飞；</br><i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
	                           maxlength="40"/>
	                    <em class="lt-not-null">*</em>
	                    <select class="day-count" name="dayNumber" >
	                        <option value="1">1</option>
	                        <option value="2">2</option>
	                        <option value="3">3</option>
	                        <option value="4">4</option>
	                        <option value="5">5</option>
	                        <option value="6">6</option>
	                        <option value="7">7</option>
	                        <option value="8">8</option>
	                        <option value="9">9</option>
	                        <option value="10">10</option>
	                        <option value="11">11</option>
	                        <option value="12">12</option>
	                        <option value="13">13</option>
	                        <option value="14">14</option>
	                        <option value="15">15</option>
	                        <option value="16">16</option>
	                        <option value="17">17</option>
	                        <option value="18">18</option>
	                        <option value="19">19</option>
	                        <option value="20">20</option>
	                        <option value="21">21</option>
	                        <option value="22">22</option>
	                        <option value="23">23</option>
	                        <option value="24">24</option>
	                        <option value="25">25</option>
	                        <option value="26">26</option>
	                        <option value="27">27</option>
	                        <option value="28">28</option>
	                        <option value="29">29</option>
	                        <option value="30">30</option>
	                    </select>日
	                    <select class="night-count" name="nightNumber" >
	                        <option value="">-</option>
	                        <option value="0">0</option>
	                        <option value="1">1</option>
	                        <option value="2">2</option>
	                        <option value="3">3</option>
	                        <option value="4">4</option>
	                        <option value="5">5</option>
	                        <option value="6">6</option>
	                        <option value="7">7</option>
	                        <option value="8">8</option>
	                        <option value="9">9</option>
	                        <option value="10">10</option>
	                        <option value="11">11</option>
	                        <option value="12">12</option>
	                        <option value="13">13</option>
	                        <option value="14">14</option>
	                        <option value="15">15</option>
	                        <option value="16">16</option>
	                        <option value="17">17</option>
	                        <option value="18">18</option>
	                        <option value="19">19</option>
	                        <option value="20">20</option>
	                        <option value="21">21</option>
	                        <option value="22">22</option>
	                        <option value="23">23</option>
	                        <option value="24">24</option>
	                        <option value="25">25</option>
	                        <option value="26">26</option>
	                        <option value="27">27</option>
	                        <option value="28">28</option>
	                        <option value="29">29</option>
	                        <option value="30">30</option>
	                        <option value="31">31</option>
	                    </select>晚
	                    <select class="add-playtype" name="playType" >
	                    	<option value="">---</option>
	                        <option value="FREEDOM">自由行</option>
	                    </select>
	                </p>
	                <p class="add-name-input">
	                    <b>产品名称副标题：</b>
	                    <input type="text" placeholder="大型活动" name="largeActivity" class="input-text lt-w100 add-dxhd"  
	                           data-tip="此输入框为<i class='add-blue'>非必填</i> <br/> 填写大型活动或专题的产品定义；如519大促、节后抄底。 <br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
	                           maxlength="100"/>
	                    <input type="text" placeholder="促销信息" name="benefit" class="input-text lt-w100 add-cxxx"
	                           data-tip="此输入框为<i class='add-blue'>非必填</i> <br/> 输入促销类型的营销词，如：满1000减100； <br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
	                           maxlength="100"/>
						<input type="text" placeholder="酒店信息" name="hotel"  class="input-text lt-w100 add-hotel"
	                           data-tip="此输入框为<i class='add-blue'>非必填</i> <br/> 填写当前产品酒店简称，星级以中文字填写（可选项，达到准四无挂牌可用“精品”二字），如有多个酒店选择用或连接，如希尔顿或万豪或喜来登；<br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
	                           maxlength="100"/>
	                    <em class="lt-not-null">*</em>
	                    <input type="text" placeholder="产品特色" name="mainFeature"  class="input-text lt-w100 add-cpts"
	                           data-tip="此输入框为<i class='add-red'>必填</i> <br/> 输入产品卖点，此款产品最大亮点，如：港龙直飞不转机、米其林餐厅饕餮盛宴等；<br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
	                           maxlength="100"/>
	                    <a class="lt-mr15 name-view-btn" href="javascript:">预览</a>
	                </p>
	                <div class="addName-help-tips clearfix">
	                    <p class="bzts">帮助提示：</p>
	
	                    <p class="bz-content"></p>
	                </div>
	
	                <p class="add-name-view">
	                    <b>名称预览：</b>
	                    <span class="add-name-content"></span>
	                </p>
	            </div>
	        </div>
	        <div class="dialog-footer">
	            <button class="lt-button lt-mr15 lt-dialog-confirm">确认</button>&nbsp;
	            <button class="lt-button lt-mr15 lt-mr15-grey lt-dialog-close">取消</button>
	        </div>
	    </div>
	</div>
</#if>
<!--/自由行——国内增加名称END-->
<!--/自由行——出境港澳台增加名称START-->
<div class="dialog dialog-default lt_dialog addName_dialog addName_zyx_cj_dialog FOREIGNLINE">
    <div class="dialog-inner clearfix">
        <a data-dismiss="dialog" class="dialog-close lt-dialog-close">&times;</a>

        <div class="dialog-header">添加出境港澳台产品名称</div>
        <div class="dialog-body">
            <div class="dialog-content clearfix">
                <p class="add-name-input">
                    <b>产品名称主标题：</b>
                    <em class="lt-not-null">*</em>
                    
                    <input type="hidden" class="add-main-title"/>
                    <input type="hidden" class="add-sub-title"/>
                    <input type="hidden" class="add-sub-title-4-tnt"/>
                    
                    <input type="text" placeholder="目的地" name="destination" class="input-text lt-w100 add-mdd"
                           data-tip="此输入框为<i class='add-red'>必填</i> <br/>填写城市名称、景区名称，以顿号为间隔；</br><i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="40"/>
                    <select class="day-count" name="dayNumber" >
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                        <option value="8">8</option>
                        <option value="9">9</option>
                        <option value="10">10</option>
                        <option value="11">11</option>
                        <option value="12">12</option>
                        <option value="13">13</option>
                        <option value="14">14</option>
                        <option value="15">15</option>
                        <option value="16">16</option>
                        <option value="17">17</option>
                        <option value="18">18</option>
                        <option value="19">19</option>
                        <option value="20">20</option>
                        <option value="21">21</option>
                        <option value="22">22</option>
                        <option value="23">23</option>
                        <option value="24">24</option>
                        <option value="25">25</option>
                        <option value="26">26</option>
                        <option value="27">27</option>
                        <option value="28">28</option>
                        <option value="29">29</option>
                        <option value="30">30</option>
                    </select>日
                    <select class="night-count" name="nightNumber" >
                        <option value="">-</option>
                        <option value="0">0</option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                        <option value="8">8</option>
                        <option value="9">9</option>
                        <option value="10">10</option>
                        <option value="11">11</option>
                        <option value="12">12</option>
                        <option value="13">13</option>
                        <option value="14">14</option>
                        <option value="15">15</option>
                        <option value="16">16</option>
                        <option value="17">17</option>
                        <option value="18">18</option>
                        <option value="19">19</option>
                        <option value="20">20</option>
                        <option value="21">21</option>
                        <option value="22">22</option>
                        <option value="23">23</option>
                        <option value="24">24</option>
                        <option value="25">25</option>
                        <option value="26">26</option>
                        <option value="27">27</option>
                        <option value="28">28</option>
                        <option value="29">29</option>
                        <option value="30">30</option>
                        <option value="31">31</option>
                    </select>晚
                    <em class="lt-not-null">*</em>
                   &nbsp;&nbsp;&nbsp;自由行
                </p>
                <p class="add-name-input">
                    <b>产品名称副标题：</b>
                    <input type="text" placeholder="优惠活动" name="benefit" class="input-text lt-w100 add-yhhd"
                           data-tip="此输入框为<i class='add-blue'>非必填</i>项 <br/> 填写产品参与活动，如买一送一，南京银行立减1000 <br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <input type="text" placeholder="主题内容" name="themeContent" class="input-text lt-w100 add-thct"
                           data-tip="此输入框为<i class='add-blue'>非必填</i> <br/> 填写产品的主题内容，输入产品核心内容比如：浪漫樱花季、亲子欢乐、体验之旅<br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <input type="text" placeholder="酒店名称或特色" name="hotelOrFeature"  class="input-text lt-w100 add-hotelorfeature"
                           data-tip="此输入框为<i class='add-blue'>非必填</i> <br/> 填写酒店名称或特色，如有多个酒店选择用或连接，如希尔顿或万豪或喜来登<br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <input type="text" placeholder="航班特色" name="flightFeature"  class="input-text lt-w100 add-flightfeature"
                           data-tip="此输入框为<i class='add-blue'>非必填</i> <br/> 填写航班特色，如双飞，xx直飞等<br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <input type="text" placeholder="其他特色" name="otherFeature"  class="input-text lt-w100 add-otherfeature"
                           data-tip="此输入框为<i class='add-blue'>非必填</i> <br/> 填写酒店特色<br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <select class="add-levelStar" name="levelStar" data-tip="此下拉框为<i class='add-blue'>非必选</i> <br/> 输入产品星级，包含：目的地--行程涵盖的主要目的地写出来（也可体现主要景点名称）<br/>">
                        <option value="0">无星级</option>
                        <option value="1">一星</option>
                        <option value="2">二星</option>
                        <option value="3">三星</option>
                        <option value="4">四星</option>
                        <option value="5">五星</option>
                        <option value="6">六星</option>
                        <option value="7">七星</option>
                        <option value="8">八星</option>
                    </select>
                    <a class="lt-mr15 name-view-btn" href="javascript:">预览</a>
                </p>
                <div class="addName-help-tips clearfix">
                    <p class="bzts">帮助提示：</p>

                    <p class="bz-content"></p>
                </div>

                <p class="add-name-view">
                    <b>名称预览：</b>
                    <span class="add-name-content"></span>
                </p>
            </div>
        </div>
        <div class="dialog-footer">
            <button class="lt-button lt-mr15 lt-dialog-confirm">确认</button>&nbsp;
            <button class="lt-button lt-mr15 lt-mr15-grey lt-dialog-close">取消</button>
        </div>
    </div>
</div>
<!--/自由行——出境港澳台增加名称-->
<#elseif bizCategory??&&bizCategory.categoryId == '15'||prodProduct??&&prodProduct.bizCategory.categoryId == '15' >
<!--/跟团游——国内增加名称START-->
<div class="dialog dialog-default lt_dialog addName_dialog addName_gty_gn_dialog INNERLINE">
    <div class="dialog-inner clearfix">
        <a data-dismiss="dialog" class="dialog-close lt-dialog-close">&times;</a>
        <div class="dialog-header">添加国内产品名称</div>
        <div class="dialog-body">
            <div class="dialog-content clearfix">
                <p class="add-name-input">
                    <b>产品名称主标题：</b>
                    <input type="hidden" class="add-main-title"/>
                    <input type="hidden" class="add-sub-title"/>
                    <input type="hidden" class="add-sub-title-4-tnt"/>
                    
                    <em class="lt-not-null">*</em>
                    <input type="text" placeholder="目的地" name="destination" class="input-text lt-w100 add-mdd"
                           data-tip="此输入框为<i class='add-red'>必填</i> <br/>填写城市名称、景区名称，以顿号为间隔，*星、纯玩/精品，星级以中文字填写（可不填，达到准四无挂牌可用“精品”二字）；如“三亚天涯海角、大东海纯玩”</br><i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="40"/>
                    <input type="text" placeholder="交通方式" name="traffic" class="input-text lt-w100 add-traffic"
                           data-tip="此输入框为<i class='add-red'>必填</i> <br/>填写产品的交通方式，巴士（不能写“汽车”）、轮船、快艇、慢艇、高铁、动车、火车、飞机  如：双飞；</br><i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="40"/>
                    <em class="lt-not-null">*</em>
                    <select class="day-count" name="dayNumber" >
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                        <option value="8">8</option>
                        <option value="9">9</option>
                        <option value="10">10</option>
                        <option value="11">11</option>
                        <option value="12">12</option>
                        <option value="13">13</option>
                        <option value="14">14</option>
                        <option value="15">15</option>
                        <option value="16">16</option>
                        <option value="17">17</option>
                        <option value="18">18</option>
                        <option value="19">19</option>
                        <option value="20">20</option>
                        <option value="21">21</option>
                        <option value="22">22</option>
                        <option value="23">23</option>
                        <option value="24">24</option>
                        <option value="25">25</option>
                        <option value="26">26</option>
                        <option value="27">27</option>
                        <option value="28">28</option>
                        <option value="29">29</option>
                        <option value="30">30</option>
                    </select>日
                    <select class="night-count" name="nightNumber">
                        <option value="">-</option>
                        <option value="0">0</option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                        <option value="8">8</option>
                        <option value="9">9</option>
                        <option value="10">10</option>
                        <option value="11">11</option>
                        <option value="12">12</option>
                        <option value="13">13</option>
                        <option value="14">14</option>
                        <option value="15">15</option>
                        <option value="16">16</option>
                        <option value="17">17</option>
                        <option value="18">18</option>
                        <option value="19">19</option>
                        <option value="20">20</option>
                        <option value="21">21</option>
                        <option value="22">22</option>
                        <option value="23">23</option>
                        <option value="24">24</option>
                        <option value="25">25</option>
                        <option value="26">26</option>
                        <option value="27">27</option>
                        <option value="28">28</option>
                        <option value="29">29</option>
                        <option value="30">30</option>
                        <option value="31">31</option>
                    </select>晚
                    <select class="add-playtype" name="playType" >
                    	<option value="">---</option>
                        <option value="WITH_GROUP">跟团</option>
                        <option value="DEPTH">深度</option>
                        <option value="SEMI_SELF">半自助</option>
                    </select>游
                </p>
                <p class="add-name-input">
                    <b>产品名称副标题：</b>
                    <input type="text" placeholder="大型活动" name="largeActivity" class="input-text lt-w100 add-dxhd"  
                           data-tip="此输入框为<i class='add-blue'>非必填</i> <br/> 填写大型活动或专题的产品定义；如519大促、节后抄底。 <br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <input type="text" placeholder="促销信息" name="benefit" class="input-text lt-w100 add-cxxx"
                           data-tip="此输入框为<i class='add-blue'>非必填</i>项 <br/> 输入促销类型的营销词，如：满1000减100； <br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <em class="lt-not-null">*</em>
                    <input type="text" placeholder="产品特色" name="mainFeature"  class="input-text lt-w100 add-cpts"
                           data-tip="此输入框为<i class='add-red'>必填</i> <br/> 输入产品卖点，此款产品最大亮点，如：港龙直飞不转机、米其林餐厅饕餮盛宴等；<br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <a class="lt-mr15 name-view-btn" href="javascript:">预览</a>
                </p>
                <div class="addName-help-tips clearfix">
                    <p class="bzts">帮助提示：</p>

                    <p class="bz-content"></p>
                </div>

                <p class="add-name-view">
                    <b>名称预览：</b>
                    <span class="add-name-content"></span>
                </p>
            </div>
        </div>
        <div class="dialog-footer">
            <button class="lt-button lt-mr15 lt-dialog-confirm">确认</button>&nbsp;
            <button class="lt-button lt-mr15 lt-mr15-grey lt-dialog-close">取消</button>
        </div>
    </div>
</div>
<!--/跟团游——国内增加名称END-->
<!--/跟团游——出境港澳台增加名称START-->
<div class="dialog dialog-default lt_dialog addName_dialog addName_gty_cj_dialog FOREIGNLINE">
    <div class="dialog-inner clearfix">
        <a data-dismiss="dialog" class="dialog-close lt-dialog-close">&times;</a>

        <div class="dialog-header">添加出境港澳台产品名称</div>
        <div class="dialog-body">
            <div class="dialog-content clearfix">
                <p class="add-name-input">
                    <b>产品名称主标题：</b>
                    <em class="lt-not-null">*</em>
                    
                    <input type="hidden" class="add-main-title"/>
                    <input type="hidden" class="add-sub-title"/>
                    <input type="hidden" class="add-sub-title-4-tnt"/>
                    
                    <input type="text" placeholder="目的地" name="destination" class="input-text lt-w100 add-mdd"
                           data-tip="此输入框为<i class='add-red'>必填</i> <br/>填写城市名称、景区名称，以顿号为间隔；</br><i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="40"/>
                    <select class="day-count" name="dayNumber" >
                        <option value="">-</option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                        <option value="8">8</option>
                        <option value="9">9</option>
                        <option value="10">10</option>
                        <option value="11">11</option>
                        <option value="12">12</option>
                        <option value="13">13</option>
                        <option value="14">14</option>
                        <option value="15">15</option>
                        <option value="16">16</option>
                        <option value="17">17</option>
                        <option value="18">18</option>
                        <option value="19">19</option>
                        <option value="20">20</option>
                        <option value="21">21</option>
                        <option value="22">22</option>
                        <option value="23">23</option>
                        <option value="24">24</option>
                        <option value="25">25</option>
                        <option value="26">26</option>
                        <option value="27">27</option>
                        <option value="28">28</option>
                        <option value="29">29</option>
                        <option value="30">30</option>
                    </select>日
                    <select class="night-count" name="nightNumber" >
                        <option value="">-</option>
                        <option value="0">0</option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                        <option value="8">8</option>
                        <option value="9">9</option>
                        <option value="10">10</option>
                        <option value="11">11</option>
                        <option value="12">12</option>
                        <option value="13">13</option>
                        <option value="14">14</option>
                        <option value="15">15</option>
                        <option value="16">16</option>
                        <option value="17">17</option>
                        <option value="18">18</option>
                        <option value="19">19</option>
                        <option value="20">20</option>
                        <option value="21">21</option>
                        <option value="22">22</option>
                        <option value="23">23</option>
                        <option value="24">24</option>
                        <option value="25">25</option>
                        <option value="26">26</option>
                        <option value="27">27</option>
                        <option value="28">28</option>
                        <option value="29">29</option>
                        <option value="30">30</option>
                        <option value="31">31</option>
                    </select>晚
                    <em class="lt-not-null">*</em>
                    <select class="add-playtype" name="playType" >
                    	<option value="">---</option>
                        <option value="DEPTH">深度</option>
                        <option value="SEMI_SELF">半自助</option>
                        <option value="CLASSIC">经典</option>
                        <option value="FULL_VIEW">全景</option>
                        <option value="ONE_DEPTH">一国深度</option>
                        <option value="TWO_ONLINE">二国连线</option>
                        <option value="MANY_ONLINE">多国连线</option>
                        <option value="CJ_SXY">舒享</option>
                        <option value="CJ_JHY">精华</option>
                    </select>游
                </p>
                <p class="add-name-input">
                    <b>产品名称副标题：</b>
                    <input type="text" placeholder="优惠活动" name="benefit" class="input-text lt-w100 add-yhhd"
                           data-tip="此输入框为<i class='add-blue'>非必填</i>项 <br/> 填写产品参与活动，如买一送一，南京银行立减1000 <br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <input type="text" placeholder="主题内容" name="themeContent" class="input-text lt-w100 add-thct placeholder"
                           data-tip="此输入框为<i class='add-blue'>非必填</i> <br/> 填写产品的主题内容，输入产品核心内容比如：浪漫樱花季、亲子欢乐、体验之旅<br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <input type="text" placeholder="酒店信息" name="hotel"  class="input-text lt-w100 add-hotel"
                           data-tip="此输入框为<i class='add-blue'>非必填</i> <br/> 填写当前产品酒店简称，如有多个酒店选择用或连接，如希尔顿或万豪或喜来登<br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <em class="lt-not-null">*</em>
                    <input type="text" placeholder="特色卖点" name="mainFeature"  class="input-text lt-w100 add-tsmd"
                           data-tip="此输入框为<i class='add-red'>必填</i> <br/> 填写产品卖点<br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <select class="add-levelStar" name="levelStar" data-tip="此下拉框为<i class='add-red'>必选</i> <br/> 输入产品星级，包含：目的地--行程涵盖的主要目的地写出来（也可体现主要景点名称）<br/>">
                        <option value="0">无星级</option>
                        <option value="1">一星</option>
                        <option value="2">二星</option>
                        <option value="3">三星</option>
                        <option value="4">四星</option>
                        <option value="5">五星</option>
                        <option value="6">六星</option>
                        <option value="7">七星</option>
                        <option value="8">八星</option>
                    </select>
                    <a class="lt-mr15 name-view-btn" href="javascript:">预览</a>
                </p>
                <div class="addName-help-tips clearfix">
                    <p class="bzts">帮助提示：</p>

                    <p class="bz-content"></p>
                </div>

                <p class="add-name-view">
                    <b>名称预览：</b>
                    <span class="add-name-content"></span>
                </p>
            </div>
        </div>
        <div class="dialog-footer">
            <button class="lt-button lt-mr15 lt-dialog-confirm">确认</button>&nbsp;
            <button class="lt-button lt-mr15 lt-mr15-grey lt-dialog-close">取消</button>
        </div>
    </div>
</div>
<!--/跟团游——出境港澳台增加名称-->
<#elseif bizCategory??&&bizCategory.categoryId == '16'||prodProduct??&&prodProduct.bizCategory.categoryId == '16' >
<!--/当地游——国内增加名称START-->
<div class="dialog dialog-default lt_dialog addName_dialog addName_gn_dialog INNERLINE">
    <div class="dialog-inner clearfix">
        <a data-dismiss="dialog" class="dialog-close lt-dialog-close">&times;</a>
        <div class="dialog-header">添加国内产品名称</div>
        <div class="dialog-body">
            <div class="dialog-content clearfix">
                <p class="add-name-input">
                    <b>产品名称主标题：</b>
                    <input type="hidden" class="add-main-title"/>
                    <input type="hidden" class="add-sub-title"/>
                    <input type="hidden" class="add-sub-title-4-tnt"/>
                    
                    <em class="lt-not-null">*</em>
                    <input type="text" placeholder="目的地" name="destination" class="input-text lt-w100 add-mdd"
                           data-tip="此输入框为<i class='add-red'>必填</i> <br/>填写城市名称、景区名称，以顿号为间隔，*星、纯玩/精品，星级以中文字填写（可不填，达到准四无挂牌可用“精品”二字）；如“三亚天涯海角、大东海纯玩”</br><i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="40"/>
                    <input type="text" placeholder="交通方式" name="traffic" class="input-text lt-w100 add-traffic"
                           data-tip="此输入框为<i class='add-red'>必填</i> <br/>填写产品的交通方式，巴士（不能写“汽车”）、轮船、快艇、慢艇、高铁、动车、火车、飞机  如：双飞；</br><i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="40"/>
                    <em class="lt-not-null">*</em>
                    <select class="day-count" name="dayNumber" >
                        <option value="半">半</option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                        <option value="8">8</option>
                        <option value="9">9</option>
                        <option value="10">10</option>
                        <option value="11">11</option>
                        <option value="12">12</option>
                        <option value="13">13</option>
                        <option value="14">14</option>
                        <option value="15">15</option>
                        <option value="16">16</option>
                        <option value="17">17</option>
                        <option value="18">18</option>
                        <option value="19">19</option>
                        <option value="20">20</option>
                        <option value="21">21</option>
                        <option value="22">22</option>
                        <option value="23">23</option>
                        <option value="24">24</option>
                        <option value="25">25</option>
                        <option value="26">26</option>
                        <option value="27">27</option>
                        <option value="28">28</option>
                        <option value="29">29</option>
                        <option value="30">30</option>
                    </select>日
                    <select class="night-count" name="nightNumber">
                        <option value="">-</option>
                        <option value="0">0</option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                        <option value="8">8</option>
                        <option value="9">9</option>
                        <option value="10">10</option>
                        <option value="11">11</option>
                        <option value="12">12</option>
                        <option value="13">13</option>
                        <option value="14">14</option>
                        <option value="15">15</option>
                        <option value="16">16</option>
                        <option value="17">17</option>
                        <option value="18">18</option>
                        <option value="19">19</option>
                        <option value="20">20</option>
                        <option value="21">21</option>
                        <option value="22">22</option>
                        <option value="23">23</option>
                        <option value="24">24</option>
                        <option value="25">25</option>
                        <option value="26">26</option>
                        <option value="27">27</option>
                        <option value="28">28</option>
                        <option value="29">29</option>
                        <option value="30">30</option>
                        <option value="31">31</option>
                    </select>晚
                    <select class="add-playtype" name="playType" >
                    	<option value="">---</option>
                        <option value="LOCAL">当地</option>
                        <option value="DEPTH">深度</option>
                    </select>游
                </p>
                <p class="add-name-input">
                    <b>产品名称副标题：</b>
                    <input type="text" placeholder="大型活动" name="largeActivity" class="input-text lt-w100 add-dxhd"  
                           data-tip="此输入框为<i class='add-blue'>非必填</i> <br/> 填写大型活动或专题的产品定义；如519大促、节后抄底。 <br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <input type="text" placeholder="促销信息" name="benefit" class="input-text lt-w100 add-cxxx"
                           data-tip="此输入框为<i class='add-blue'>非必填</i>项 <br/> 输入促销类型的营销词，如：满1000减100； <br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <em class="lt-not-null">*</em>
                    <input type="text" placeholder="产品特色" name="mainFeature"  class="input-text lt-w100 add-cpts"
                           data-tip="此输入框为<i class='add-red'>必填</i> <br/> 输入产品卖点，此款产品最大亮点，如：港龙直飞不转机、米其林餐厅饕餮盛宴等；<br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <a class="lt-mr15 name-view-btn" href="javascript:">预览</a>
                </p>
                <div class="addName-help-tips clearfix">
                    <p class="bzts">帮助提示：</p>

                    <p class="bz-content"></p>
                </div>

                <p class="add-name-view">
                    <b>名称预览：</b>
                    <span class="add-name-content"></span>
                </p>
            </div>
        </div>
        <div class="dialog-footer">
            <button class="lt-button lt-mr15 lt-dialog-confirm">确认</button>&nbsp;
            <button class="lt-button lt-mr15 lt-mr15-grey lt-dialog-close">取消</button>
        </div>
    </div>
</div>
<!--/当地游——国内增加名称END-->

<!--/当地游——出境港澳台增加名称START-->
<div class="dialog dialog-default lt_dialog addName_dialog addName_cj_dialog FOREIGNLINE">
    <div class="dialog-inner clearfix">
        <a data-dismiss="dialog" class="dialog-close lt-dialog-close">&times;</a>

        <div class="dialog-header">添加出境港澳台产品名称</div>
        <div class="dialog-body">
            <div class="dialog-content clearfix">
                <p class="add-name-input">
                    <b>产品名称主标题：</b>
                    <em class="lt-not-null">*</em>
                    
                    <input type="hidden" class="add-main-title"/>
                    <input type="hidden" class="add-sub-title"/>
                    <input type="hidden" class="add-sub-title-4-tnt"/>
                    
                    <input type="text" placeholder="目的地" name="destination" class="input-text lt-w100 add-mdd"
                           data-tip="此输入框为<i class='add-red'>必填</i> <br/>填写城市名称、景区名称，以顿号为间隔；</br><i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="40"/>
                    <select class="day-count" name="dayNumber" >
                        <option value="半">半</option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                        <option value="8">8</option>
                        <option value="9">9</option>
                        <option value="10">10</option>
                        <option value="11">11</option>
                        <option value="12">12</option>
                        <option value="13">13</option>
                        <option value="14">14</option>
                        <option value="15">15</option>
                        <option value="16">16</option>
                        <option value="17">17</option>
                        <option value="18">18</option>
                        <option value="19">19</option>
                        <option value="20">20</option>
                        <option value="21">21</option>
                        <option value="22">22</option>
                        <option value="23">23</option>
                        <option value="24">24</option>
                        <option value="25">25</option>
                        <option value="26">26</option>
                        <option value="27">27</option>
                        <option value="28">28</option>
                        <option value="29">29</option>
                        <option value="30">30</option>
                    </select>日
                    <select class="night-count" name="nightNumber" >
                        <option value="">-</option>
                        <option value="0">0</option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                        <option value="8">8</option>
                        <option value="9">9</option>
                        <option value="10">10</option>
                        <option value="11">11</option>
                        <option value="12">12</option>
                        <option value="13">13</option>
                        <option value="14">14</option>
                        <option value="15">15</option>
                        <option value="16">16</option>
                        <option value="17">17</option>
                        <option value="18">18</option>
                        <option value="19">19</option>
                        <option value="20">20</option>
                        <option value="21">21</option>
                        <option value="22">22</option>
                        <option value="23">23</option>
                        <option value="24">24</option>
                        <option value="25">25</option>
                        <option value="26">26</option>
                        <option value="27">27</option>
                        <option value="28">28</option>
                        <option value="29">29</option>
                        <option value="30">30</option>
                        <option value="31">31</option>
                    </select>晚游
                    <em class="lt-not-null">*</em>
                </p>
                <p class="add-name-input">
                    <b>产品名称副标题：</b>
                    <input type="text" placeholder="优惠活动" name="benefit" class="input-text lt-w100 add-yhhd"
                           data-tip="此输入框为<i class='add-blue'>非必填</i>项 <br/> 填写产品参与活动，如买一送一，南京银行立减1000 <br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <input type="text" placeholder="主题内容" name="themeContent" class="input-text lt-w100 add-thct placeholder"
                           data-tip="此输入框为<i class='add-blue'>非必填</i> <br/> 填写产品的主题内容，输入产品核心内容比如：浪漫樱花季、亲子欢乐、体验之旅<br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <input type="text" placeholder="酒店信息" name="hotel"  class="input-text lt-w100 add-hotel"
                           data-tip="此输入框为<i class='add-blue'>非必填</i> <br/> 填写当前产品酒店简称，如有多个酒店选择用或连接，如希尔顿或万豪或喜来登<br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <em class="lt-not-null">*</em>
                    <input type="text" placeholder="特色卖点" name="mainFeature"  class="input-text lt-w100 add-tsmd"
                           data-tip="此输入框为<i class='add-red'>必填</i> <br/> 填写产品卖点<br/> <i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
                           maxlength="100"/>
                    <select class="add-levelStar" name="levelStar" data-tip="此下拉框为<i class='add-red'>必选</i> <br/> 输入产品星级，包含：目的地--行程涵盖的主要目的地写出来（也可体现主要景点名称）<br/>">
                        <option value="0">无星级</option>
                        <option value="1">一星</option>
                        <option value="2">二星</option>
                        <option value="3">三星</option>
                        <option value="4">四星</option>
                        <option value="5">五星</option>
                        <option value="6">六星</option>
                        <option value="7">七星</option>
                        <option value="8">八星</option>
                    </select>
                    <a class="lt-mr15 name-view-btn" href="javascript:">预览</a>
                </p>
                <div class="addName-help-tips clearfix">
                    <p class="bzts">帮助提示：</p>

                    <p class="bz-content"></p>
                </div>

                <p class="add-name-view">
                    <b>名称预览：</b>
                    <span class="add-name-content"></span>
                </p>
            </div>
        </div>
        <div class="dialog-footer">
            <button class="lt-button lt-mr15 lt-dialog-confirm">确认</button>&nbsp;
            <button class="lt-button lt-mr15 lt-mr15-grey lt-dialog-close">取消</button>
        </div>
    </div>
</div>
<!--/当地游——出境港澳台增加名称-->
<!--
<#elseif bizCategory??&&bizCategory.categoryId == '17'||prodProduct??&&prodProduct.bizCategory.categoryId == '17' >
	<div class="dialog dialog-default lt_dialog addName_dialog addName_zyx_gn_dialog INNERLINE" style="position: absolute;">
	    <div class="dialog-inner clearfix">
	        <a data-dismiss="dialog" class="dialog-close lt-dialog-close">&times;</a>
	        <div class="dialog-header">添加国内产品名称</div>
	        <div class="dialog-body">
	            <div class="dialog-content clearfix">
	                <p class="add-name-input">
	                    <b>产品名称主标题：</b>
	                    <input type="hidden" class="add-main-title"/>
	                    <input type="hidden" class="add-sub-title"/>
	                    <input type="hidden" class="add-sub-title-4-tnt"/>
	                    <em class="lt-not-null">*</em>
	                    <input type="text" placeholder="目的地" name="destination" class="input-text lt-w200 js-add-mdd" maxlength="40"/>
	                    <em class="lt-not-null">*</em>
	                    <select class="day-count" name="dayNumber" >
	                        <option value="1">1</option>
	                        <option value="2">2</option>
	                        <option value="3">3</option>
	                        <option value="4">4</option>
	                        <option value="5">5</option>
	                        <option value="6">6</option>
	                        <option value="7">7</option>
	                        <option value="8">8</option>
	                        <option value="9">9</option>
	                        <option value="10">10</option>
	                        <option value="11">11</option>
	                        <option value="12">12</option>
	                        <option value="13">13</option>
	                        <option value="14">14</option>
	                        <option value="15">15</option>
	                        <option value="16">16</option>
	                        <option value="17">17</option>
	                        <option value="18">18</option>
	                        <option value="19">19</option>
	                        <option value="20">20</option>
	                        <option value="21">21</option>
	                        <option value="22">22</option>
	                        <option value="23">23</option>
	                        <option value="24">24</option>
	                        <option value="25">25</option>
	                        <option value="26">26</option>
	                        <option value="27">27</option>
	                        <option value="28">28</option>
	                        <option value="29">29</option>
	                        <option value="30">30</option>
	                    </select>天
	                    <select class="night-count" name="nightNumber" >
	                        <option value="0">0</option>
	                        <option value="1">1</option>
	                        <option value="2">2</option>
	                        <option value="3">3</option>
	                        <option value="4">4</option>
	                        <option value="5">5</option>
	                        <option value="6">6</option>
	                        <option value="7">7</option>
	                        <option value="8">8</option>
	                        <option value="9">9</option>
	                        <option value="10">10</option>
	                        <option value="11">11</option>
	                        <option value="12">12</option>
	                        <option value="13">13</option>
	                        <option value="14">14</option>
	                        <option value="15">15</option>
	                        <option value="16">16</option>
	                        <option value="17">17</option>
	                        <option value="18">18</option>
	                        <option value="19">19</option>
	                        <option value="20">20</option>
	                        <option value="21">21</option>
	                        <option value="22">22</option>
	                        <option value="23">23</option>
	                        <option value="24">24</option>
	                        <option value="25">25</option>
	                        <option value="26">26</option>
	                        <option value="27">27</option>
	                        <option value="28">28</option>
	                        <option value="29">29</option>
	                        <option value="30">30</option>
	                        <option value="31">31</option>
	                    </select>晚
	                    <input type="text" placeholder="附加信息" name="destination" class="input-text lt-w300 add-mdd-note"  maxlength="60"/>
	                </p>
	                <div class="add-name-input">
						<b>产品名称副标题：</b>
						<div class="add-content-box clearfix">
							<span class="tit">+添加酒店</span>
							<div class="add-title-box">
								<div class="add-row on">
									<span class="inquiry-common-icon down-icon"></span>
									<select id="multiple-hotel" class="form-control form-control-chosen js-from-hotel" data-placeholder="酒店必填" multiple>
										<option></option>
										
									</select>
									<p class="tips">最多支持添加10个标签</p>
								</div>
								<div class="add-row">
									<input type="text" placeholder="附加信息" name="destination" class="input-text lt-w400 hotel-add-note"	maxlength="60"/>
									<p class="tips">最多60字符</p>
								</div>
							</div>
						</div>
						<div class="add-content-box clearfix">
							<span class="tit">+添加景区</span>
							<div class="add-title-box on">
									<div class="add-row">
										<span class="inquiry-common-icon down-icon"></span>
										<select id="multiple-spot" class="form-control form-control-chosen js-from-spot" data-placeholder="景区" multiple>
											<option></option>
										</select>
										<p class="tips">最多支持添加10个标签</p>
									</div>
									<div class="add-row">
										<input type="text" placeholder="附加信息" name="destination" class="input-text lt-w400 spot-add-note"	maxlength="60"/>
										<p class="tips">最多60字符</p>
									</div>
							</div>
						</div>
						<div class="add-content-box">
								<span class="tit">+营销信息</span>
								<input type="text" placeholder="附加信息" name="destination" class="input-text lt-w400 jd-sale-mdd"
									data-tip="此输入框为<i class='add-red'>必填</i> <br/>填写城市名称、景区名称，以顿号为间隔，*星、纯玩/精品，星级以中文字填写（可不填，达到准四无挂牌可用“精品”二字）；如“三亚天涯海角、大东海纯玩”</br><i class='add-red'>请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||&quot;</i>"
									maxlength="60"/>
							</div>
					</div>
	
	                <div class="addName-help-tips clearfix">
		                 	  帮助提示:<p style="color:red">请勿输入下列字符 <> % # * & ^ @ ! ~ / \ '||"</p>
		                 	  <p style="color:red">产品主标题+副标题名称总字数不能超过200字</p>
		                </div>
	                <p class="add-name-view">
	                    <span class="js-view-btn" style="cursor: pointer;"><b>名称预览：</b></span>
	                    <span class="add-name-content"></span>
	                </p>
	            </div>
	        </div>
	        <div class="dialog-footer">
	            <button class="lt-button lt-mr15 js-dialog-confirm">确认</button>&nbsp;
	            <button class="lt-button lt-mr15 lt-mr15-grey lt-dialog-close">取消</button>
	        </div>
	    </div>
	</div>
</#if>
<!--模板START-->
<div class="lt-info-template hide">
    <!-- 产品名称模板START -->
    <p class="lt-product-name-view-main">
        <span class="lt-pnv-content-main"></span>
        <a href="javascript:;" class="lt-pnv-modify">修改</a>
        <a href="javascript:;" class="lt-pnv-delete">删除</a>
    </p>
    <p class="lt-product-name-view-sub">
        <span class="lt-pnv-content-sub"></span>
    </p>
    <!-- 产品名称模板START -->
</div>
<!--模板结束-->