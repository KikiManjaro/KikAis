import 'themes.dart';

/// A selectable basemap (free raster tile sources, no API key required).
class BaseMap {
  final String id;
  final String label;
  final String urlTemplate;
  final List<String> subdomains;
  final String attribution;

  /// Whether the style is visually dark (used to pick a good default).
  final bool dark;

  const BaseMap({
    required this.id,
    required this.label,
    required this.urlTemplate,
    required this.attribution,
    this.subdomains = const [],
    this.dark = false,
  });
}

const List<BaseMap> kBaseMaps = [
  BaseMap(
    id: 'carto-voyager',
    label: 'Voyager (light)',
    urlTemplate:
        'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
    subdomains: ['a', 'b', 'c', 'd'],
    attribution: '© OpenStreetMap contributors © CARTO',
  ),
  BaseMap(
    id: 'carto-positron',
    label: 'Positron (light minimal)',
    urlTemplate:
        'https://{s}.basemaps.cartocdn.com/rastertiles/light_all/{z}/{x}/{y}{r}.png',
    subdomains: ['a', 'b', 'c', 'd'],
    attribution: '© OpenStreetMap contributors © CARTO',
  ),
  BaseMap(
    id: 'carto-dark',
    label: 'Dark Matter',
    urlTemplate:
        'https://{s}.basemaps.cartocdn.com/rastertiles/dark_all/{z}/{x}/{y}{r}.png',
    subdomains: ['a', 'b', 'c', 'd'],
    attribution: '© OpenStreetMap contributors © CARTO',
    dark: true,
  ),
  BaseMap(
    id: 'osm',
    label: 'OpenStreetMap',
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    attribution: '© OpenStreetMap contributors',
  ),
  BaseMap(
    id: 'opentopomap',
    label: 'OpenTopoMap',
    urlTemplate: 'https://tile.opentopomap.org/{z}/{x}/{y}.png',
    attribution: '© OpenStreetMap contributors, SRTM | © OpenTopoMap (CC-BY-SA)',
  ),
  BaseMap(
    id: 'esri-satellite',
    label: 'Esri Satellite',
    urlTemplate:
        'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/'
        'MapServer/tile/{z}/{y}/{x}',
    attribution: 'Tiles © Esri — Source: Esri',
  ),
  BaseMap(
    id: 'esri-streets',
    label: 'Esri World Street Map',
    urlTemplate:
        'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/'
        'MapServer/tile/{z}/{y}/{x}',
    attribution: 'Tiles © Esri',
  ),
];

/// Resolves a basemap by id, falling back to a sensible default.
BaseMap baseMapById(String id) {
  for (final b in kBaseMaps) {
    if (b.id == id) return b;
  }
  return kBaseMaps.first;
}

/// The basemap used when the user has not picked one explicitly: it follows
/// the application theme (dark style for dark themes).
String defaultBasemapIdFor(AppTheme theme) {
  switch (theme) {
    case AppTheme.dark:
    case AppTheme.highContrast:
      return 'carto-dark';
    case AppTheme.light:
      return 'carto-voyager';
  }
}
