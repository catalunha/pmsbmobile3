## Pattern for Widgets Presentation
* Nao se esqueça variáveis tudo em ingles.
~~~
class WidgetParentDS extends StatelessWidget {
  final String text;
  final bool boolean;
  final int integer;
  final List<type> xList; // pattern for list
  final Function(String) onDelete; //pattern
  final Function(String) onX; // pattern for Functions
...
}

class WidgetParentDS extends StatefulWidget {
  final bool isCreate; //pattern
  final String text;
  final bool boolean;
  final int integer;
  final Function(String, [String,]) onCreateOrUpdate;//pattern
  final Function(String) onDelete; //pattern
...
}

class WidgetChildCDS extends StatelessWidget {
  // idem ao pattern
...
}
~~~
