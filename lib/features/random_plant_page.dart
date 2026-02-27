import 'dart:math';
import 'package:flutter/material.dart';
import 'package:botanybase/features/random_plant_entity.dart';
import 'package:botanybase/services/plant_api_service.dart';
import 'package:botanybase/features/plant_list_page.dart';

class RandomPlantPage extends StatefulWidget {
  const RandomPlantPage({super.key});

  @override
  State<RandomPlantPage> createState() => _RandomPlantPageState();
}

class _RandomPlantPageState extends State<RandomPlantPage> {
  final PlantApiService _apiService = PlantApiService();
  List<RandomPlantEntity> _plants = [];
  RandomPlantEntity? _currentPlant;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPlants();
  }

  Future<void> _fetchPlants() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final plants = await _apiService.fetchSpeciesList();
      setState(() {
        _plants = plants;
        _pickRandomPlant();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load plants. Please try again.';
        _isLoading = false;
      });
    }
  }

  void _pickRandomPlant() {
    if (_plants.isEmpty) return;
    setState(() {
      final random = Random();
      _currentPlant = _plants[random.nextInt(_plants.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          _buildContent(),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 24,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PlantListPage(),
                    ),
                  );
                },
              ),
            ),
          ),
          if (!_isLoading && _errorMessage == null)
            Positioned(
              bottom: 40,
              right: 32,
              child: FloatingActionButton.extended(
                onPressed: _pickRandomPlant,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                icon: const Icon(Icons.shuffle, size: 20),
                label: const Text(
                  'DISCOVER',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.energy_savings_leaf,
                color: Colors.white24,
                size: 64,
              ),
              const SizedBox(height: 24),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              OutlinedButton(
                onPressed: _fetchPlants,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: const Text(
                  'RETRY',
                  style: TextStyle(
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_currentPlant == null) {
      return const Center(
        child: Text(
          'No plants available',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return _buildPlantCard(_currentPlant!);
  }

  Widget _buildPlantCard(RandomPlantEntity plant) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      switchInCurve: Curves.easeOutExpo,
      switchOutCurve: Curves.easeInExpo,
      child: SizedBox.expand(
        key: ValueKey(plant.id),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (plant.imageUrl.isNotEmpty)
              Image.network(
                plant.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF1A1A1A),
                  child: const Center(
                    child: Icon(
                      Icons.yard_outlined,
                      color: Colors.white12,
                      size: 120,
                    ),
                  ),
                ),
              )
            else
              Container(
                color: const Color(0xFF1A1A1A),
                child: const Center(
                  child: Icon(
                    Icons.yard_outlined,
                    color: Colors.white12,
                    size: 120,
                  ),
                ),
              ),
            // Architectural Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.0),
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.95),
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
            // Typography & Metadata
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            plant.isIndoor
                                ? Icons.home_outlined
                                : Icons.park_outlined,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            plant.isIndoor ? 'INDOOR' : 'OUTDOOR',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      plant.name.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.5,
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ), // Spatial breathing room for FAB
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
