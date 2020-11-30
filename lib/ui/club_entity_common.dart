import 'package:flutter/material.dart';
import 'package:iit_app/external_libraries/spin_kit.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/ui/workshop_custom_widgets.dart';

class ClubAndEntityWidgets {
  // function ade non-static to allow scrollcontroller to be passed to two dirrerent tab views.
  static Widget _getWorkshopsAndEvents(
      BuiltAllWorkshopsPost workshops, bool isEvent, Function reload) {
    Widget _builder(w) {
      return w.length == 0
          ? Center(
              child:
                  Text('No Activity :(', style: TextStyle(color: Colors.white)))
          : ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: w.length,
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return WorkshopCustomWidgets.getWorkshopOrEventCard(context,
                    w: w[index], reload: reload);
              },
            );
    }

    return workshops == null
        ? Container(child: Center(child: LoadingCircle))
        : ListView(
            // shrinkWrap: true,
            children: [
              SizedBox(height: 15),
              _builder(workshops.active_workshops
                  .where((w) => isEvent ? !w.is_workshop : w.is_workshop)
                  .toList()),
              SizedBox(height: 15),
              Text(
                'Past:',
                style: TextStyle(color: Colors.white, fontSize: 25),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              _builder(workshops.past_workshops
                  .where((w) => isEvent ? !w.is_workshop : w.is_workshop)
                  .toList()),
            ],
          );
  }

  static Widget getWorkshopEventTabBar(
      {BuiltAllWorkshopsPost workshops,
      @required TabController tabController,
      BuildContext context,
      Function reload}) {
    return Container(
      margin: EdgeInsets.fromLTRB(12, 10, 12, 0),
      decoration: BoxDecoration(
          color: ColorConstants.workshopContainerBackground,
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      height: MediaQuery.of(context).size.height * 0.80,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: ColorConstants.workshopCardContainer,
              tabs: [
                Tab(text: 'Workshops'),
                Tab(text: 'Events'),
              ],
              controller: tabController,
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: <Widget>[
                  workshops == null
                      ? Container(child: Center(child: LoadingCircle))
                      : _getWorkshopsAndEvents(workshops, false, reload),
                  workshops == null
                      ? Container(child: Center(child: LoadingCircle))
                      : _getWorkshopsAndEvents(workshops, true, reload),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
