import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/resources/weather_api.dart';
import 'package:weather/weather_screen.dart';

class Model {
  final String cityName;
  final String temp;
  final String weatherName;

  Model({
    required this.cityName,
    required this.temp,
    required this.weatherName,
  });
}

class ManageCitiesPage extends StatefulWidget {
  const ManageCitiesPage({super.key});

  @override
  State<ManageCitiesPage> createState() => _ManageCitiesPageState();
}

List<Model> cities = [];
List<bool> isSelected = [];

class _ManageCitiesPageState extends State<ManageCitiesPage> {
  bool isLoading = false;
  var controller = TextEditingController();

  bool isVisible = false;
  bool isDelete = false;
  WeatherApi api = WeatherApi();
  @override
  void initState() {
    super.initState();
    getInitials();
  }

  getInitials() async {
    setState(() {
      isLoading = true;
    });
    if (cities.isEmpty) {
      var model = await api.getData('Mumbai');
      setState(() {
        cities.add(
          Model(
            cityName: model.cityName,
            temp: model.temp,
            weatherName: model.weatherName,
          ),
        );
        isSelected.add(false);
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            if (isVisible) {
              setState(() {
                isVisible = false;
              });
              return;
            } else if (isDelete) {
              setState(() {
                isDelete = false;
              });
              return;
            }
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: const Text(
          'Manage cities',
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isDelete = !isDelete;
              });
            },
            icon: const Icon(
              Icons.edit,
            ),
          ),
        ],
      ),
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: isVisible
              ? [
                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.35,
                            ),
                            SizedBox(
                              height: 55,
                              child: TextField(
                                controller: controller,
                                decoration: InputDecoration(
                                  hintText: 'Enter location',
                                  fillColor: Colors.white,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                onSubmitted: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                fixedSize: const Size(400, 50),
                              ),
                              onPressed: () async {
                                if (controller.text.isEmpty) {
                                  return;
                                }
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  isLoading = true;
                                });
                                var data =
                                    await api.getData(controller.text.trim());
                                controller.clear();
                                if (data.cityName == '' && data.temp == '') {
                                  setState(() {
                                    isVisible = true;
                                    isLoading = false;
                                  });
                                  return;
                                }
                                cities.add(
                                  Model(
                                    cityName: data.cityName,
                                    temp: data.temp,
                                    weatherName: data.weatherName,
                                  ),
                                );
                                isSelected.add(false);
                                setState(() {
                                  isVisible = false;
                                  isLoading = false;
                                });
                              },
                              child: const Text('Add'),
                            ),
                          ],
                        ),
                ]
              : [
                  SizedBox(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    child: ListView.builder(
                      itemCount: cities.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) => GestureDetector(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: !isDelete
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              height: 100,
                              width: isDelete
                                  ? size.width * 0.8
                                  : size.width * 0.9,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 65, 65, 65),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    cities[index].cityName,
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 223, 223, 223),
                                      fontSize: 20,
                                    ),
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          '${cities[index].temp} °C',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                          ),
                                        ),
                                        Text(
                                          cities[index].weatherName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 223, 223, 223),
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                            isDelete
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        cities.removeAt(index);
                                        isSelected.removeAt(index);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        ),
                        onTap: () => Get.offAll(
                          WeatherSCreen(
                            city: cities[index].cityName,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            isVisible = !isVisible;
          });
        },
      ),
    );
  }
}
